-- Exploratory Data Analysis --

SELECT *
FROM layoffs_staging2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY 1
ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY 1
ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY 1
ORDER BY 2 DESC;

-- Progression of layoffs (rolling total of layoffs)
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

WITH Rolling_Total AS
(SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_laid_off, SUM(total_laid_off) OVER (ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;


SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 1 ASC;

WITH Company_Year (company, `year`, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
)
SELECT *, DENSE_RANK() OVER (PARTITION BY `year` ORDER BY total_laid_off DESC) AS ranking
FROM Company_Year
WHERE `year` IS NOT NULL
ORDER BY ranking ASC;

-- Top 5 Companies Layoffs by Year
WITH Company_Year (company, `year`, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS 
(
SELECT *, DENSE_RANK() OVER (PARTITION BY `year` ORDER BY total_laid_off DESC) AS ranking
FROM Company_Year
WHERE `year` IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE ranking <= 5;