*** Settings ***
Library    SeleniumLibrary
Library    Collections

*** Variables ***
${BROWSER}             edge
${LOGIN_URL}           https://www.saucedemo.com/
${VALID_USERNAME}      standard_user
${VALID_PASSWORD}      secret_sauce
${INVALID_USERNAME}    invalid_user
${INVALID_PASSWORD}    wrongpassword
${USERNAME_FIELD}      id=user-name
${PASSWORD_FIELD}      id=password
${LOGIN_BUTTON}        id=login-button
${ERROR_MESSAGE}       class=error-message-container
${INVENTORY_PAGE}      //*[@id="inventory_container"]

*** Test Cases ***
# Critical Test Cases
TC_LOGIN_001_Login_With_Valid_Credentials
    [Documentation]    ผู้ใช้สามารถเข้าสู่ระบบได้สำเร็จด้วยชื่อผู้ใช้และรหัสผ่านที่ถูกต้อง
    [Tags]    Critical    Happy_Path
    Open Browser    ${LOGIN_URL}    ${BROWSER}
    Input Text    ${USERNAME_FIELD}    ${VALID_USERNAME}
    Input Text    ${PASSWORD_FIELD}    ${VALID_PASSWORD}
    Click Button    ${LOGIN_BUTTON}
    Wait Until Element Is Visible    ${INVENTORY_PAGE}    timeout=5s
    Close Browser

# High Priority Test Cases
TC_LOGIN_002_Login_With_Invalid_Username
    [Documentation]    ปฏิเสธการเข้าสู่ระบบเนื่องจากชื่อผู้ใช้ไม่ถูกต้อง
    [Tags]    High    Negative
    Open Browser    ${LOGIN_URL}    ${BROWSER}
    Input Text    ${USERNAME_FIELD}    ${INVALID_USERNAME}
    Input Text    ${PASSWORD_FIELD}    ${VALID_PASSWORD}
    Click Button    ${LOGIN_BUTTON}
    Wait Until Element Is Visible    ${ERROR_MESSAGE}    timeout=5s
    Element Should Contain    ${ERROR_MESSAGE}    Epic sadface
    Close Browser

TC_LOGIN_003_Login_With_Invalid_Password
    [Documentation]    ปฏิเสธการเข้าสู่ระบบเนื่องจากรหัสผ่านไม่ถูกต้อง
    [Tags]    High    Negative
    Open Browser    ${LOGIN_URL}    ${BROWSER}
    Input Text    ${USERNAME_FIELD}    ${VALID_USERNAME}
    Input Text    ${PASSWORD_FIELD}    ${INVALID_PASSWORD}
    Click Button    ${LOGIN_BUTTON}
    Wait Until Element Is Visible    ${ERROR_MESSAGE}    timeout=5s
    Close Browser

TC_LOGIN_004_Login_With_Empty_Username
    [Documentation]    ปฏิเสธการเข้าสู่ระบบหากช่องชื่อผู้ใช้ว่างเปล่า
    [Tags]    High    Validation
    Open Browser    ${LOGIN_URL}    ${BROWSER}
    Input Text    ${PASSWORD_FIELD}    ${VALID_PASSWORD}
    Click Button    ${LOGIN_BUTTON}
    Wait Until Element Is Visible    ${ERROR_MESSAGE}    timeout=5s
    Element Should Contain    ${ERROR_MESSAGE}    Epic sadface
    Close Browser

TC_LOGIN_005_Login_With_Empty_Password
    [Documentation]    ปฏิเสธการเข้าสู่ระบบเมื่อช่องรหัสผ่านว่างเปล่า
    [Tags]    High    Validation
    Open Browser    ${LOGIN_URL}    ${BROWSER}
    Input Text    ${USERNAME_FIELD}    ${VALID_USERNAME}
    Click Button    ${LOGIN_BUTTON}
    Wait Until Element Is Visible    ${ERROR_MESSAGE}    timeout=5s
    Close Browser

TC_LOGIN_006_Login_With_Empty_Credentials
    [Documentation]    ปฏิเสธการเข้าสู่ระบบหากทั้งสองช่องว่าง
    [Tags]    High    Validation
    Open Browser    ${LOGIN_URL}    ${BROWSER}
    Click Button    ${LOGIN_BUTTON}
    Wait Until Element Is Visible    ${ERROR_MESSAGE}    timeout=5s
    Close Browser

TC_LOGIN_007_Logout_Functionality
    [Documentation]    ผู้ใช้สามารถออกจากระบบได้สำเร็จ
    [Tags]    High    Happy_Path
    Open Browser    ${LOGIN_URL}    ${BROWSER}
    Input Text    ${USERNAME_FIELD}    ${VALID_USERNAME}
    Input Text    ${PASSWORD_FIELD}    ${VALID_PASSWORD}
    Click Button    ${LOGIN_BUTTON}
    Wait Until Element Is Visible    ${INVENTORY_PAGE}    timeout=5s
    Click Button    id=react-burger-menu-btn
    Wait Until Element Is Visible    id=logout_sidebar_link    timeout=5s
    Click Link    id=logout_sidebar_link
    Wait Until Element Is Visible    ${LOGIN_BUTTON}    timeout=5s
    Close Browser

# Medium Priority Test Cases
TC_LOGIN_008_Special_Characters_In_Password
    [Documentation]    ยอมรับการเข้าสู่ระบบที่มีอักขระพิเศษในข้อมูลประจำตัวที่ถูกต้อง
    [Tags]    Medium    Boundary
    Open Browser    ${LOGIN_URL}    ${BROWSER}
    Input Text    ${USERNAME_FIELD}    ${VALID_USERNAME}
    Input Text    ${PASSWORD_FIELD}    ${VALID_PASSWORD}
    Click Button    ${LOGIN_BUTTON}
    Wait Until Element Is Visible    ${INVENTORY_PAGE}    timeout=5s
    Close Browser

TC_LOGIN_009_Case_Sensitivity_Test
    [Documentation]    ทดสอบว่าการเข้าสู่ระบบนั้นคำนึงถึงตัวพิมพ์ใหญ่และตัวพิมพ์เล็กหรือไม่
    [Tags]    Medium    Boundary
    Open Browser    ${LOGIN_URL}    ${BROWSER}
    Input Text    ${USERNAME_FIELD}    STANDARD_USER
    Input Text    ${PASSWORD_FIELD}    ${VALID_PASSWORD}
    Click Button    ${LOGIN_BUTTON}
    Wait Until Element Is Visible    ${ERROR_MESSAGE}    timeout=5s
    Close Browser

TC_LOGIN_010_Session_Timeout
    [Documentation]    ตรวจสอบว่าเซสชันหมดอายุหลังจากไม่มีการใช้งานหรือไม่
    [Tags]    Medium    Performance
    Open Browser    ${LOGIN_URL}    ${BROWSER}
    Input Text    ${USERNAME_FIELD}    ${VALID_USERNAME}
    Input Text    ${PASSWORD_FIELD}    ${VALID_PASSWORD}
    Click Button    ${LOGIN_BUTTON}
    Wait Until Element Is Visible    ${INVENTORY_PAGE}    timeout=5s
    Sleep    5s
    Reload Page
    Element Should Be Visible    ${INVENTORY_PAGE}
    Close Browser

TC_LOGIN_011_SQL_Injection_Prevention
    [Documentation]    แอปพลิเคชันควรป้องกันการโจมตีแบบ SQL injection
    [Tags]    Critical    Security
    Open Browser    ${LOGIN_URL}    ${BROWSER}    
    Input Text    ${USERNAME_FIELD}    admin' OR '1'='1
    Input Text    ${PASSWORD_FIELD}    test
    Click Button    ${LOGIN_BUTTON}
    Wait Until Element Is Visible    ${ERROR_MESSAGE}    timeout=5s
    Close Browser

TC_LOGIN_012_XSS_Prevention
    [Documentation]   ช่องชื่อผู้ใช้/รหัสผ่านควรป้องกันการโจมตี XSS
    [Tags]    Critical    Security
    Open Browser    ${LOGIN_URL}    ${BROWSER}
    Input Text    ${USERNAME_FIELD}    <script>alert('xss')</script>
    Input Text    ${PASSWORD_FIELD}    test
    Click Button    ${LOGIN_BUTTON}
    Wait Until Element Is Visible    ${ERROR_MESSAGE}    timeout=5s
    Close Browser


TC_LOGIN_013_Failed_Login_Attempt_Lockout
    [Documentation]   บัญชีควรถูกล็อกหลังจากพยายามเข้าสู่ระบบผิดพลาดหลายครั้ง
    [Tags]    High    Security
    Open Browser    ${LOGIN_URL}    ${BROWSER}
    FOR    ${i}    IN RANGE    6
        Input Text    ${USERNAME_FIELD}    ${VALID_USERNAME}
        Input Text    ${PASSWORD_FIELD}    ${INVALID_PASSWORD}
        Click Button    ${LOGIN_BUTTON}
        Wait Until Element Is Visible    ${ERROR_MESSAGE}    timeout=5s
    END
    Close Browser


TC_LOGIN_014_Back_Button_After_Logout
    [Documentation]    ปุ่มย้อนกลับไม่ควรเข้าถึงหน้าเว็บที่ได้รับการป้องกันหลังจากออกจากระบบแล้ว
    [Tags]    Medium    Security
    Open Browser    ${LOGIN_URL}    ${BROWSER}
    Input Text    ${USERNAME_FIELD}    ${VALID_USERNAME}
    Input Text    ${PASSWORD_FIELD}    ${VALID_PASSWORD}
    Click Button    ${LOGIN_BUTTON}
    Wait Until Element Is Visible    ${INVENTORY_PAGE}    timeout=5s
    Click Button    id=react-burger-menu-btn
    Wait Until Element Is Visible    id=logout_sidebar_link    timeout=5s
    Click Link    id=logout_sidebar_link
    Wait Until Element Is Visible    ${LOGIN_BUTTON}    timeout=5s
    Go Back
    Element Should Be Visible    ${LOGIN_BUTTON}
    Close Browser

*** Keywords ***
Login With Valid Credentials
    [Documentation]    Keyword to login with valid credentials
    Input Text    ${USERNAME_FIELD}    ${VALID_USERNAME}
    Input Text    ${PASSWORD_FIELD}    ${VALID_PASSWORD}
    Click Button    ${LOGIN_BUTTON}
    Wait Until Element Is Visible    ${INVENTORY_PAGE}    timeout=5s

Logout User
    [Documentation]    Keyword to logout user
    Click Button    id=react-burger-menu-btn
    Wait Until Element Is Visible    id=logout_sidebar_link    timeout=5s
    Click Link    id=logout_sidebar_link
    Wait Until Element Is Visible    ${LOGIN_BUTTON}    timeout=5s
