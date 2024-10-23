-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging2;

-- Looking at Percentage to see how big these layoffs were
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2 WHERE percentage_laid_off IS NOT NULL;

-- Which companies had 1 which is basically 100 percent of they company laid off
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1 ;

-- if we order by funcs_raised_millions we can see how big some of these companies were
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1 
order by funds_raised_millions DESC;

-- Companies with the most Total Layoff
SELECT company, sum(total_laid_off)
FROM layoffs_staging2 
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- by country
SELECT country, sum(total_laid_off)
FROM layoffs_staging2 
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(`date`), sum(total_laid_off)
FROM layoffs_staging2 
GROUP BY YEAR(`date`) 
ORDER BY 1 ASC;

SELECT industry, sum(total_laid_off)
FROM layoffs_staging2 
GROUP BY industry
ORDER BY 2 DESC;

SELECT stage, sum(total_laid_off)
FROM layoffs_staging2 
GROUP BY stage
ORDER BY 2 DESC;

SELECT company,YEAR(`date`), sum(total_laid_off)
FROM layoffs_staging2 
GROUP BY company, YEAR(`date`)
ORDER BY  3 DESC;

--  Display data with top 5 Rank company per year based on total laid off 
WITH Company_Year (company, years, total_laid_off)AS
(
SELECT company,YEAR(`date`), sum(total_laid_off)
FROM layoffs_staging2 
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(
SELECT *, dense_rank() OVER (partition by years order by total_laid_off DESC) AS Ranking FROM Company_Year
WHERE years IS NOT NULL
)
SELECT * FROM Company_Year_Rank
WHERE Ranking <= 5 ;

-- Rolling Total of Layoffs Per Month
SELECT substring(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
from layoffs_staging2
WHERE substring(`date`,1,7) IS NOT NULL
GROUP BY `MONTH` ORDER BY 1 ASC;

-- Rolling Total of Layoffs Per Month use with CTE

WITH Rolling_Total AS
(
SELECT substring(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
from layoffs_staging2
WHERE substring(`date`,1,7) IS NOT NULL
GROUP BY `MONTH` ORDER BY 1 ASC
)
SELECT `MONTH` , total_off,SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total 
FROM Rolling_Total;



