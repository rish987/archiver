# -*- coding: utf-8 -*-

# Sample Python code for youtube.videos.update
# See instructions for running these code samples locally:
# https://developers.google.com/explorer-help/guides/code_samples#python

import os
import sys
import pickle

import google_auth_oauthlib.flow
import googleapiclient.discovery
import googleapiclient.errors

scopes = ["https://www.googleapis.com/auth/youtube.force-ssl"]

with open(sys.argv[4]) as file:
    desc = file.read()

def main():
    # Disable OAuthlib's HTTPS verification when running locally.
    # *DO NOT* leave this option enabled in production.
    os.environ["OAUTHLIB_INSECURE_TRANSPORT"] = "1"

    api_service_name = "youtube"
    api_version = "v3"
    client_secrets_file = sys.argv[1]

    credentials = ""
    try:
        with open("creds.pkl", "rb") as file:
            credentials = pickle.load(file)
    except:
        # Get credentials and create an API client
        flow = google_auth_oauthlib.flow.InstalledAppFlow.from_client_secrets_file(
            client_secrets_file, scopes)
        credentials = flow.run_console()
        with open("creds.pkl", "wb") as file:
            pickle.dump(credentials, file)

    youtube = googleapiclient.discovery.build(
        api_service_name, api_version, credentials=credentials)

    request = youtube.videos().update(
        part="snippet",
        body={
          "id": sys.argv[2],
          "snippet": {
            "categoryId": 22,
            "title": sys.argv[3],
            "description": desc
          }
        }
    )
    response = request.execute()

    print(response)

if __name__ == "__main__":
    main()
