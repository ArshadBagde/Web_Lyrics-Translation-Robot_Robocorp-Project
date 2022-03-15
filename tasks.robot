*** Settings ***
Documentation     Google Translate Song Lyrics from source to target language.
...               Saves the original and the translated lyrics as text files.
Library           RPA.Browser
Library           RPA.Desktop
Library           OperatingSystem
Task Teardown     Close All Browsers

*** Variables ***
${SONGS_NAME}=    %{SONGS_NAME=peaches}
${SOURCE_LANG}=    %{SOURCE_LANG=en}
${TARGET_LANG}=    %{TARGET_LANG=es}
${ORIGINAL_FILE}=    ${OUTPUT_DIR}${/}${SONGS_NAME}-${SOURCE_LANG}-original.text
${Translation_FILE}=    ${OUTPUT_DIR}${/}${SONGS_NAME}-${TARGET_LANG}-Translation.text

*** Keywords ***
Get Lyrics
    #Open Available Browser    https://www.lyrics.com/lyrics/peaches
    Open Available Browser    https://www.lyrics.com/lyrics/${SONGS_NAME}
    Click Element When Visible    css:.best-matches a
    ${lyrics_element}=    Set Variable    id:lyric-body-text
    Wait Until Element Is Visible    ${lyrics_element}
    ${lyrics}=    Get Text    ${lyrics_element}
    [Return]    ${lyrics}

*** Keywords ***
Translate
    [Arguments]    ${lyrics}
    Go To    https://translate.google.co.in/?sl=${SOURCE_LANG}&tl=${TARGET_LANG}&text=${lyrics}
    ${Translation_Element}    Set Variable    xpath://*[@id="yDmH0d"]/c-wiz/div/div[2]/c-wiz/div[2]/c-wiz/div[1]/div[2]/div[3]/c-wiz[2]/div[6]/div/div[1]
    Wait Until Element Is Visible    ${Translation_Element}
    ${Translation}=    Get Text    ${Translation_Element}
    [Return]    ${Translation}

*** Keywords ***
Save Lyrics
    [Arguments]    ${lyrics}    ${Translation}
    Create File    ${ORIGINAL_FILE}    ${lyrics}
    Create File    ${Translation_FILE}    ${Translation}

*** Tasks ***
Google Translate song Lyrics from source to target language
    ${lyrics}=    Get Lyrics
    ${Translation}=    Translate    ${lyrics}
    Save Lyrics    ${lyrics}    ${Translation}

Minimal task
    Log    Done.
