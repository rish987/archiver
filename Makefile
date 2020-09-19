# --- core dependencies ---
PROJECTS_DIR := projects
SOURCE_DIR := src
OUTPUT_DIR := output
TREE_O_DIR := ${OUTPUT_DIR}/tree_online
DEFS_DIR := ${OUTPUT_DIR}/defs
FORMAT_DIR := format
BUILD_DIR := build
BUILD_SOURCE_DIR := ${BUILD_DIR}/src
BUILD_BASENAME := ref
BUILD_DEFS_BASENAME := defs

# TODO wrapper

PROJECTS := $(shell find projects -maxdepth 1 -mindepth 1 -type d | cut -f2- -d/)

SOURCE_LIST = $(subst ./,,$(shell cd ${PROJECTS_DIR} && find \. -type f \( ! -name '.*.sw*' \) -a \( ! -name 'refnum' \)))
REFNUMS_LIST = $(subst ./,,$(shell cd ${PROJECTS_DIR} && find \. -type f \( -name 'refnum' \)))
BUILD_SOURCE_LIST = $(addprefix ${BUILD_SOURCE_DIR}/,${SOURCE_LIST})
BUILD_REFNUMS_LIST = $(addprefix ${BUILD_SOURCE_DIR}/,${REFNUMS_LIST})

get_dir_list = $(subst .tex,,$(shell cd ${PROJECTS_DIR}/$(2) && { find ./ -type d -name "$(1)" | xargs -i find "{}" -maxdepth 1 -mindepth 1 | cut -f2- -d/; }))

get_out_list = $(addprefix ${OUTPUT_DIR}/$(2)/$(3)/$(2)/,$(addsuffix /$(4),$(call get_dir_list,$(1),$(2))))
get_defs_list = $(addsuffix /defs.pdf,$(call get_dir_list,$(1)))


get_tree_list = ${OUTPUT_DIR}/$(1)/$(2)/$(1)/$(3) $(call get_out_list,proof,$(1),$(2),$(3)) $(call get_out_list,note,$(1),$(2),$(3)) $(call get_out_list,topic,$(1),$(2),$(3)) $(call get_out_list,definition,$(1),$(2),$(3))

test:
	echo $(addprefix ${PROJECTS_DIR}/,$(addsuffix /*.mk,${PROJECTS}))

D_TO = $(dir $@)
D_ABV = $(dir $@)/..
CD_TO = cd ${D_TO}
CD_ABV = cd ${D_ABV}

ARCHIVES := archives/ref.pdf
ARCHIVES_F := ${OUTPUT_DIR}/full.pdf
ARCHIVES_F_C := ${OUTPUT_DIR}/full_compact.pdf
ARCHIVES_F_SRC := ${BUILD_SOURCE_DIR}/full.tex

TREE := $(foreach project,${PROJECTS},$(call get_tree_list,${project},tree,ref.pdf))
TREE_O := $(foreach project,${PROJECTS},$(call get_tree_list,${project},tree_online,ref.pdf))
DEFS := $(foreach project,${PROJECTS},$(call get_tree_list,${project},defs,defs.pdf))

WRAPPER_DIR := format/wrappers
BUILD_WRAPPER_DIR := ${BUILD_SOURCE_DIR}/wrappers

TREE_WRAPPER := ${BUILD_WRAPPER_DIR}/tree.m4
TREE_O_WRAPPER := ${BUILD_WRAPPER_DIR}/tree_online.m4
FULL_WRAPPER := ${BUILD_WRAPPER_DIR}/full.m4
FULL_COMPACT_WRAPPER := ${BUILD_WRAPPER_DIR}/full_compact.m4
DEFS_WRAPPER := ${BUILD_WRAPPER_DIR}/defs.m4

BUILD_WRAPPERS := ${TREE_WRAPPER} ${TREE_O_WRAPPER} ${FULL_WRAPPER} ${FULL_COMPACT_WRAPPER} ${DEFS_WRAPPER} 

BUILD_FORMAT := $(addprefix ${BUILD_SOURCE_DIR}/scripts/,defs_inheritance.sh relpathln.py defs_inheritance.py path_fmt.py format_defs.sh) ${BUILD_SOURCE_DIR}/archives.cls

all : tree tree_online defs

tree : ${TREE}
tree_online : ${TREE_O}
defs : ${DEFS}
full : ${ARCHIVES_F}
full_compact : ${ARCHIVES_F_C}

.SECONDEXPANSION :

$(addsuffix /tree,${PROJECTS}) : $$(call get_tree_list,$$(subst /,,$$(dir $$@)),tree,ref.pdf)
$(addsuffix /tree_online,${PROJECTS}) : $$(call get_tree_list,$$(subst /,,$$(dir $$@)),tree_online,ref.pdf)
$(addsuffix /defs,${PROJECTS}) : $$(call get_tree_list,$$(subst /,,$$(dir $$@)),defs,defs.pdf)

refname = $(subst /ref.pdf,,$(shell echo $@ | cut -f4- -d/))
refnamed = $(subst /defs.pdf,,$(shell echo $@ | cut -f4- -d/))

${TREE}: $$(addprefix $${BUILD_SOURCE_DIR}/,$$(shell scripts/get_deps.sh $${refname})) | ${BUILD_DIR} ${BUILD_SOURCE_DIR}
	find ${BUILD_DIR} -maxdepth 1 -type f | xargs rm -f
	m4 -Dinput_ref="${refname}" ${TREE_WRAPPER} > ${BUILD_DIR}/${BUILD_BASENAME}.tex
	cd ${BUILD_DIR} && pdflatex --halt-on-error --shell-escape ${BUILD_BASENAME}.tex
	mkdir -p $(dir $@) && cp ${BUILD_DIR}/${BUILD_BASENAME}.pdf $@

${TREE_O}: $$(addprefix $${BUILD_SOURCE_DIR}/,$$(shell scripts/get_deps.sh $${refname})) | ${BUILD_DIR} ${BUILD_SOURCE_DIR}
	find ${BUILD_DIR} -maxdepth 1 -type f | xargs rm -f
	m4 -Dinput_ref="${refname}" ${TREE_O_WRAPPER} > ${BUILD_DIR}/${BUILD_BASENAME}.tex
	cd ${BUILD_DIR} && pdflatex --halt-on-error --shell-escape ${BUILD_BASENAME}.tex
	mkdir -p $(dir $@) && cp ${BUILD_DIR}/${BUILD_BASENAME}.pdf $@

${DEFS}: $$(addprefix $${BUILD_SOURCE_DIR}/,$$(shell scripts/get_deps_defs.sh $${refnamed})) | ${BUILD_DIR} ${BUILD_SOURCE_DIR}
	find ${BUILD_DIR} -maxdepth 1 -type f | xargs rm -f
	m4 -Dinput_ref="${refnamed}" ${DEFS_WRAPPER} > ${BUILD_DIR}/${BUILD_DEFS_BASENAME}.tex
	cd ${BUILD_DIR} && pdflatex --halt-on-error --shell-escape ${BUILD_DEFS_BASENAME}.tex
	mkdir -p $(dir $@) && cp ${BUILD_DIR}/${BUILD_DEFS_BASENAME}.pdf $@

${ARCHIVES_F} ${ARCHIVES_F_C}: ${ARCHIVES_F_SRC} ${BUILD_SOURCE_LIST} ${BUILD_REFNUMS_LIST} | ${BUILD_DIR} ${OUTPUT_DIR} ${BUILD_SOURCE_DIR}
	find ${BUILD_DIR} -maxdepth 1 -type f | xargs rm -f
	m4 -Dinput=${ARCHIVES_F_SRC} ${BUILD_WRAPPER_DIR}/$(basename $(notdir $@)).m4 > ${BUILD_DIR}/${BUILD_BASENAME}.tex
	cd ${BUILD_DIR} && latexmk --halt-on-error --pdf --shell-escape ${BUILD_BASENAME}.tex
	mkdir -p $(dir $@) && cp ${BUILD_DIR}/${BUILD_BASENAME}.pdf $@

${ARCHIVES_F_SRC} : ${BUILD_SOURCE_LIST} | ${BUILD_SOURCE_DIR}
	{ echo "\includereference{archives}"; for path in $$(cd ${BUILD_SOURCE_DIR} && find . -type d -a \( -name proof -o -name note -o -name topic -o -name definition \) | xargs -i find "{}" -maxdepth 1 -mindepth 1); do echo "\includereference{$$(echo $$path | cut -f2- -d/)}"; done; } > ${ARCHIVES_F_SRC}

${BUILD_SOURCE_LIST} ${BUILD_REFNUMS_LIST} : $${PROJECTS_DIR}/$$(shell echo "$$@" | cut -d'/' -f3-) | ${BUILD_DIR}
	mkdir -p $(dir $@)
	cp $< $(dir $@)

${BUILD_FORMAT} : $${FORMAT_DIR}/$$(shell echo "$$@" | cut -d'/' -f3-) | ${BUILD_DIR}
	mkdir -p $(dir $@)
	cp $< $(dir $@)

${BUILD_WRAPPERS} : $${WRAPPER_DIR}/$$(notdir $$@) | ${BUILD_DIR}
	mkdir -p $(dir $@)
	cp $< $(dir $@)

${BUILD_DIR} ${OUTPUT_DIR} ${BUILD_SOURCE_DIR} ${TREE_O_DIR}:
	mkdir -p $@

${ARCHIVES_F} ${ARCHIVES_F_C} ${ARCHIVES_F_C} ${TREE} ${TREE_O} ${DEFS} : ${BUILD_SOURCE_DIR}/archives.cls ${BUILD_FORMAT}
${ARCHIVES_F} : ${FULL_WRAPPER}
${ARCHIVES_F_C} : ${FULL_COMPACT_WRAPPER}
${TREE} : ${TREE_WRAPPER}
${TREE_O} : ${TREE_O_WRAPPER}
${DEFS} : ${DEFS_WRAPPER}

clean : 
	-rm -rf build output

TREE_DIRS = $(addsuffix /tree,$(addprefix ${OUTPUT_DIR}/,${PROJECTS})) $(addsuffix /tree_online,$(addprefix ${OUTPUT_DIR}/,${PROJECTS}))
# --- 

-include $(addprefix ${PROJECTS_DIR}/,$(addsuffix /*.mk,${PROJECTS}))
