from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
import math
import time
import os
from bs4 import BeautifulSoup
from selenium.webdriver.common.keys import Keys
import time, urllib.request
import pandas as pd

options = Options()
options.add_argument('--window-size=974,1047')
options.add_argument('--window-position=953,0')
options.add_experimental_option("detach", True)

search = input("검색어를 입력하세요: ")
data_num = int(input('크롤링 할 건수는 몇 건? '))

URL = 'https://korean.visitkorea.or.kr/search/search_list.do?keyword='+search

driver = webdriver.Chrome(options=options)
driver.get(URL)
time.sleep(3)

# 여행기사 더보기 클릭
driver.find_element(By.CSS_SELECTOR, '#s_recommend>.more_view>a').click()

# 수집할 데이터 개수 입력 받기
num = 0

start_page = 1
goal_page = math.ceil(data_num / 10)
# 제목 추출 xpath
tit_path = '//*[@id="search_result"]/ul/li[*]/div[1]/div[1]/a'


data_list = []

for p in range(start_page, goal_page+1):
    print(f'===== {p} 페이지 =====')
    titles = driver.find_elements(By.XPATH, tit_path) # driver.find_element(By.CSS_SELECTOR, '#search_result')
    time.sleep(1)
    
    for t in titles:
        num += 1
        if num > data_num:
            break
        title = t.text
        print(num, title)
        
        data_dic = {}
        data_dic['Title'] = title
        
        # 제목 클릭
        driver.execute_script('arguments[0].click()', t)
        
        # 상세정보 수집
        time.sleep(2)
        texts = driver.find_elements(By.CSS_SELECTOR, '.txt_p p')
        text_list = [ t.text for t in texts ]
        text_merge = ' '.join(text_list)
        data_dic['Text'] = text_merge
        data_list.append(data_dic)
        
        # 이미지 저장
        time.sleep(2)
        f_dir = f'여행기사/{search}/{num}'
        os.makedirs(os.getcwd() + '/' + f_dir, exist_ok=True)
        
        html_src = driver.page_source
        html_dom = BeautifulSoup(html_src, 'lxml')
        
        img_list = html_dom.select('.img_typeBox img')
        cdn_list = []
        for img in img_list:
            cdn_list.append(img["src"])
        no = 0
        for src in cdn_list:
            # 다운로드
            urllib.request.urlretrieve(src, f'{f_dir}/{no}.jpg')
            no+=1
        
        # back
        time.sleep(2)
        driver.back()
        
    if num < data_num:
        time.sleep(2)
        next_button = driver.find_element(By.CSS_SELECTOR, f"a[id='{p+1}']")
        driver.execute_script("arguments[0].click();", next_button)
        time.sleep(2)

df = pd.DataFrame(data_list)
df.to_csv(f'여행기사/{search}.csv', index=False, encoding='cp949') # 특정 문자에서 인코딩 문제 있음
driver.close()
print('========= 작업 완료 =========')