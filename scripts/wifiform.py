from selenium import webdriver

def main():
    browser = webdriver.Firefox()
    browser.get("https://lms.fcps.edu")
    browser.maximize_window()

if __name__ == "__main__":
    main()
