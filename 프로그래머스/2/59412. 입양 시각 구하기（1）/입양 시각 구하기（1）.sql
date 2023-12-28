-- 코드를 입력하세요
# SELECT EXTRACT(HOUR FROM DATETIME) AS HOUR, COUNT(ANIMAL_ID) AS COUNT
# FROM ANIMAL_OUTS
# GROUP BY HOUR
# HAVING HOUR BETWEEN 9 AND 19
# ORDER BY HOUR



SELECT DATE_FORMAT(DATETIME, '%H') AS HOUR, COUNT(ANIMAL_ID) AS COUNT
FROM ANIMAL_OUTS
GROUP BY HOUR
HAVING HOUR BETWEEN 9 AND 19
ORDER BY HOUR