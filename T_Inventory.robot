*** Settings ***
Library             SeleniumLibrary
Library             DateTime
Library             Collections

Suite Setup         Open Browser And Login
Suite Teardown      Close All Browsers

*** Variables ***
${BASE_URL}             https://www.saucedemo.com
${INVENTORY_URL}        https://www.saucedemo.com/inventory.html
${BROWSER}              edge
${USERNAME}             standard_user
${PASSWORD}             secret_sauce
${LOAD_TIMEOUT}         3s
${IMPLICIT_WAIT}        10s

# Locators
${LOGIN_USERNAME}       id=user-name
${LOGIN_PASSWORD}       id=password
${LOGIN_BUTTON}         id=login-button
${PAGE_TITLE}           class=title
${ITEM_NAMES}           class=inventory_item_name
${SORT_DROPDOWN}        class=product_sort_container

*** Keywords ***
# ------------------------------------------------------------------
# Keyword: เปิดเบราว์เซอร์และเข้าสู่ระบบ
# ------------------------------------------------------------------
Open Browser And Login
    Open Browser    ${BASE_URL}    ${BROWSER}
    Set Selenium Implicit Wait    ${IMPLICIT_WAIT}
    Input Text    ${LOGIN_USERNAME}    ${USERNAME}
    Input Text    ${LOGIN_PASSWORD}    ${PASSWORD}
    Click Button    ${LOGIN_BUTTON}
    Wait Until Page Contains Element    ${PAGE_TITLE}    timeout=10s


# ------------------------------------------------------------------
# Keyword: กลับสู่หน้า Inventory
# ------------------------------------------------------------------
Navigate To Inventory
    [Documentation]    นำทางกลับมายังหน้า Inventory เพื่อเตรียมพร้อมสำหรับ Test Case ถัดไป
    Go To    ${INVENTORY_URL}
    Wait Until Element Is Visible    ${PAGE_TITLE}    timeout=10s

# ------------------------------------------------------------------
# Keyword: ดึงรายชื่อสินค้าทั้งหมด
# ------------------------------------------------------------------
Get All Product Names
    [Documentation]    คืนค่า List ของชื่อสินค้าทั้งหมดบนหน้า Inventory
    ${elements}=    Get WebElements    ${ITEM_NAMES}
    ${names}=       Create List
    FOR    ${el}    IN    @{elements}
        ${text}=    Get Text    ${el}
        Append To List    ${names}    ${text}
    END
    RETURN    ${names}

*** Test Cases ***

# ==============================================================================
# SECTION 1 : Positive / Negative Test Cases
# ==============================================================================
TC001 แสดสินค้าทั้งหมดในหน้า Inventory ได้อย่างถูกต้อง
    [Documentation]     ตรวจสอบว่าหน้า Inventory แสดงสินค้าครบ 6 รายการหลังจาก Login สำเร็จ
    Navigate To Inventory
    ${items}=    Get WebElements    ${ITEM_NAMES}
    ${count}=    Get Length    ${items}
    Should Be Equal As Integers    ${count}    6
    ...    msg=คาดว่าจะมีสินค้า 6 รายการ แต่พบ ${count} รายการ

TC-002 กรองสินค้าจาก A ถึง Z ได้ถูกต้อง
    [Documentation]    เลือก Sort "Name (A to Z)" แล้วตรวจสอบว่าสินค้าเรียงลำดับตัวอักษรจาก A ถึง Z ถูกต้อง
    Navigate To Inventory
    Select From List By Value    ${SORT_DROPDOWN}    az
    ${names}=        Get All Product Names
    ${sorted}=       Evaluate    sorted(${names})
    Lists Should Be Equal    ${names}    ${sorted}
    ...    msg=สินค้าไม่ได้เรียงลำดับจาก A ถึง Z
