*** Settings ***
Library           SeleniumLibrary
Test Teardown    Close Browser

*** Test Cases ***

Test Simple
    log to console    Coucou
    TRY
        Open Browser    http://www.google.com  headlesschrome  options=add_argument("--no-sandbox")
    EXCEPT
        sleep    10s
        log to console    Retry begin session
        Open Browser    https://robotframework.org  headlesschrome  options=add_argument("--no-sandbox")
    END
    log to console    Fini