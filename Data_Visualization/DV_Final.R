rm(list = ls())
setwd('C:/Users/daess/Desktop/final_dv')

library(ggplot2)
library(dplyr)
library(sf)
library(XML)
library(readxl)
library(ggthemes)

# 행정구역 shp 불러오기
shp <- st_read('./서울시3d/행정구역.shp')


# API 인증키
service_key <- '(인증키)'

# API 불러오기
api <- data.frame()

for(i in 0:23){
  url= paste0('http://openapi.seoul.go.kr:8088/', 
             service_key,
             '/xml/SPOP_LOCAL_RESD_DONG/', 
             424*i+1, '/' ,(i+1)*424, 
             '/20210606')
  item_list= xmlParse(url, encoding='UTF-8')
  item_list = getNodeSet(item_list, '//row')
  item_dat = xmlToDataFrame(item_list, stringsAsFactors=F)
  api = rbind(api, item_dat)
}

# shp와 api를 보면 행정동코드가 완전히 다르다
# 서울시 열린데이터 광장에서 두 코드를 모두 갖고 있는 행정동코드_매핑정보 자료 이용
code <- read_excel('./행정동코드_매핑정보_20200325.xlsx',
                   sheet = '행정동코드',
                   col_names = TRUE)
code <- code[-1,] %>% select(통계청행정동코드, 행자부행정동코드)
colnames(code) <- c('ADM_CD', 'ADSTRD_CODE_SE')

shp <- merge(shp, code, by = 'ADM_CD')

# 필요한 데이터 추출
data <- api %>% select(STDR_DE_ID, TMZON_PD_SE, ADSTRD_CODE_SE, TOT_LVPOP_CO)

# 총생활인구수가 문자형으로 되어있기 때문에 숫자형으로 변환해준다 
data$TOT_LVPOP_CO <- as.numeric(data$TOT_LVPOP_CO)


# 2번
setwd('C:/Users/daess/Desktop/final_dv/2/image')
for (i in 0:23) {
  hour <- sprintf('%02d', i)
  h_data <- data %>% filter(TMZON_PD_SE == hour)
  map <- left_join(shp, h_data, by = 'ADSTRD_CODE_SE')
  map$highlight <- ifelse(map$TOT_LVPOP_CO == max(map$TOT_LVPOP_CO), 'highlight', 'normal')
  textdf <- map[map$TOT_LVPOP_CO == max(map$TOT_LVPOP_CO),]
  
  fname = paste0('./spopvis_20210606',hour,'.jpg')
  
  title = paste0('time : ', hour)
  p <- map %>% ggplot + geom_sf(aes(fill = TOT_LVPOP_CO), colour = 'white', 
                                alpha = 1, size = 0.5) +
    scale_fill_viridis_c(begin = 0.1) +
    ggtitle(title) +
    theme(title = )
   
  p + geom_sf_label(data = textdf, aes(label = ADM_NM), label.padding = unit(0.1, 'line'), label.size = 0.25)
  
  ggsave(fname)
}

# 3번
library(rayshader)

for (i in 0:23) {
  hour <- sprintf('%02d', i)
  h_data <- data %>% filter(TMZON_PD_SE == hour)
  map <- left_join(shp, h_data, by = 'ADSTRD_CODE_SE')
  map$highlight <- ifelse(map$TOT_LVPOP_CO == max(map$TOT_LVPOP_CO), 'highlight', 'normal')
  textdf <- map[map$TOT_LVPOP_CO == max(map$TOT_LVPOP_CO),]
  
  title <- paste0('time : ', hour)
  p <- map %>% ggplot + geom_sf(aes(fill = TOT_LVPOP_CO), colour = 'white', alpha = 1, size = 0.5) +
    scale_fill_viridis_c(begin = 0.1) +
    theme(plot.title = element_text(size = 15, color = 'blue'))
  
  p <- p + geom_sf_label(data = textdf, aes(label = ADM_NM), label.padding = unit(0.1, 'line'), label.size = 0.25)
  
  plot_gg(p, multicore = TRUE, width = 6, height = 6)
  
  for (j in 0:11){
    render_camera(theta = i*12 + j, phi = 50)
    render_snapshot(file = paste0('./3/3d_image/',sprintf('%03d', i*12+j)), 
                    title_text = title, title_position = 'northwest',
                    title_size = 15, title_color = 'black')
  }
}

#gif로 만들기
install.packages('av')
library(av)

setwd('C:/Users/daess/Desktop/final_dv/3/3d_image')
dir <- './'
list.files(dir, '*.png')
av::av_encode_video(list.files(dir, '*.png'), framerate = 24,
                    output = 'final.mp4')
