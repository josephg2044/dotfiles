from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
import time
import subprocess

def main():
    userinfo = subprocess.check_output('pass ion', shell=True).split()

    browser = webdriver.Firefox()
    browser.get("https://ion.tjhsst.edu")
    # browser.find_element(By.NAME, 'username').send_keys(userinfo[0])
    # browser.find_element(By.NAME, 'password').send_keys(userinfo[])

    browser.find_element(By.XPATH, '/html/body/div[3]/div/div[1]/ul/li[17]/div[2]/a[1]/div/span[1]').click()
    browser.find_element(By.XPATH, '/html/body/div[3]/div/div[3]/div[3]/ul[4]/li[65]').click()
    browser.find_element(By.XPATH, '//*[@id="signup-button"]').click()

    browser.quit()
    del userinfo
if __name__ == "__main__":
    main()
