PROJECTS_DIR := archives
OUTPUT_DIR := output
FORMAT_DIR := format
BUILD_DIR := build
BUILD_SOURCE_DIR := ${BUILD_DIR}/src
PROJECTS := $(shell find ${PROJECTS_DIR} -maxdepth 1 -mindepth 1 -type d | cut -f2- -d/)

SHELL := /bin/bash

source_list = $(shell cd ${PROJECTS_DIR} && find $(1) -type f -a \( ! -regex '.*/\..*' \))
build_source_list = $(addprefix ${BUILD_SOURCE_DIR}/,$(call source_list,$(1)))

get_dir_list = $(shell cd ${PROJECTS_DIR}/$(1) && { find ./ -type d \( -name "proof" -o -name "note" -o -name "topic" -o -name "definition" \) | xargs -i find "{}" -maxdepth 1 -mindepth 1 | cut -f2- -d/; })

get_out_list = $(addprefix ${OUTPUT_DIR}/$(2)/$(1)/,$(addsuffix /$(2).pdf,$(call get_dir_list,$(1))))

get_tree_list = ${OUTPUT_DIR}/$(2)/$(1)/$(2).pdf $(call get_out_list,$(1),$(2))

test:
	echo $(addprefix ${PROJECTS_DIR}/,$(addsuffix /*.mk,${PROJECTS}))

F_SRC := ${BUILD_DIR}/full_inp.tex

WRAPPER_DIR := format/wrappers
BUILD_WRAPPER_DIR := ${BUILD_SOURCE_DIR}/wrappers

BUILD_WRAPPERS := $(addsuffix .m4,$(addprefix ${BUILD_WRAPPER_DIR}/,tree tree_online full full_compact defs))

BUILD_FORMAT := $(addprefix ${BUILD_SOURCE_DIR}/scripts/,defs_inheritance.sh relpathln.py defs_inheritance.py refnum_fmt.sh refpartnum_fmt.sh path_fmt.py format_defs.sh) ${BUILD_SOURCE_DIR}/archives.cls

#.PHONY : tree tree_online defs full full_compact archive/tree demo/tree archive/tree_online archive/tree_online demo/tree_online

tree : $(foreach project,${PROJECTS},$(call get_tree_list,${project},tree))
tree_online : $(foreach project,${PROJECTS},$(call get_tree_list,${project},tree_online))
defs : $(foreach project,${PROJECTS},$(call get_tree_list,${project},defs))
full : $(addsuffix /full.pdf,$(addprefix ${OUTPUT_DIR}/full/,${PROJECTS}))
full_compact : $(addsuffix /full_compact.pdf,$(addprefix ${OUTPUT_DIR}/full_compact/,${PROJECTS}))

.SECONDEXPANSION :

$(addsuffix /tree,${PROJECTS}) : $$(call get_tree_list,$$(subst /,,$$(dir $$@)),tree)
$(addsuffix /tree_online,${PROJECTS}) : $$(call get_tree_list,$$(subst /,,$$(dir $$@)),tree_online)
$(addsuffix /defs,${PROJECTS}) : $$(call get_tree_list,$$(subst /,,$$(dir $$@)),defs)

BASENAME = $(basename $(notdir $@))
WRAPPER = ${BUILD_WRAPPER_DIR}/${BASENAME}.m4
type = $(shell echo $* | cut -d'/' -f1)
preamble = ${BUILD_SOURCE_DIR}/${type}/preamble.tex

${OUTPUT_DIR}/tree/%/tree.pdf ${OUTPUT_DIR}/tree_online/%/tree_online.pdf ${OUTPUT_DIR}/defs/%/defs.pdf : $$(addprefix $${BUILD_SOURCE_DIR}/,$$(shell scripts/get_deps.sh $$* $${BASENAME})) $${WRAPPER} ${BUILD_SOURCE_DIR}/archives.cls ${BUILD_FORMAT} | ${BUILD_DIR} ${BUILD_SOURCE_DIR}
	find ${BUILD_DIR} -maxdepth 1 -type f | xargs rm -f
	m4 -Da_preamble="${preamble}" -Dinput_ref="$*" ${WRAPPER} > ${BUILD_DIR}/${BASENAME}.tex
	cd ${BUILD_DIR} && latexmk --pdf --halt-on-error --shell-escape ${BASENAME}.tex
	mkdir -p $(dir $@) && cp ${BUILD_DIR}/${BASENAME}.pdf $@

${OUTPUT_DIR}/full/%/full.pdf ${OUTPUT_DIR}/full_compact/%/full_compact.pdf: $$(call build_source_list,$$*) $${WRAPPER} ${BUILD_SOURCE_DIR}/archives.cls ${BUILD_FORMAT} | ${BUILD_DIR} ${OUTPUT_DIR} ${BUILD_SOURCE_DIR}
	find ${BUILD_DIR} -maxdepth 1 -type f | xargs rm -f
	( echo '\includereference{$*}'; cd ${BUILD_SOURCE_DIR}; i=1; while results=$$(find $* -mindepth $$i -maxdepth $$i -type d -a \( -name proof -o -name note -o -name topic -o -name definition \) | xargs -i find "{}" -maxdepth 1 -mindepth 1) && [[ -n $$results ]]; do for path in $$results; do echo "\\includereference{$$path}"; done; (( i += 2 )); done; ) > ${F_SRC}
	m4 -Da_preamble="${preamble}" -Dinput=${F_SRC} ${WRAPPER} > ${BUILD_DIR}/${BASENAME}.tex
	cd ${BUILD_DIR} && latexmk --halt-on-error --pdf --shell-escape ${BASENAME}.tex
	mkdir -p $(dir $@) && cp ${BUILD_DIR}/${BASENAME}.pdf $@

${BUILD_SOURCE_DIR}/% : $${PROJECTS_DIR}/$$(shell echo "$$@" | cut -d'/' -f3-) | ${BUILD_DIR}
	mkdir -p $(dir $@)
	cp $< $(dir $@)

.PRECIOUS : ${BUILD_SOURCE_DIR}/%

${BUILD_FORMAT} : $${FORMAT_DIR}/$$(shell echo "$$@" | cut -d'/' -f3-) | ${BUILD_DIR}
	mkdir -p $(dir $@)
	cp $< $(dir $@)

${BUILD_WRAPPERS} : $${WRAPPER_DIR}/$$(notdir $$@) | ${BUILD_DIR}
	mkdir -p $(dir $@)
	cp $< $(dir $@)

${BUILD_DIR} ${OUTPUT_DIR} ${BUILD_SOURCE_DIR}:
	mkdir -p $@

clean : 
	-rm -rf build output

-include $(addprefix ${PROJECTS_DIR}/,$(addsuffix /*.mk,${PROJECTS}))
