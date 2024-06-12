# World Layoffs Data Analysis

## Description

This project involved conducting data cleaning and exploratory data analysis on a comprehensive World Layoffs dataset using MySQL. The primary goal was to transform raw data into a structured and insightful format by performing advanced SQL queries to derive key insights.

## Data Cleaning Process

### 1. Remove Duplicates

- **Create a staging table:**
  ```sql
  CREATE TABLE layoffs_staging LIKE layoffs;

  INSERT INTO layoffs_staging
  SELECT * FROM layoffs;
  ```

- **Identify and remove duplicate rows:**
  ```sql
  WITH duplicate_cte AS (
      SELECT *,
      ROW_NUMBER() OVER (
          PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
      ) AS row_num
      FROM layoffs_staging
  )
  SELECT * FROM duplicate_cte WHERE row_num > 1;

  DELETE FROM layoffs_staging2 WHERE row_num > 1;
  ```

### 2. Standardize the Data

- **Trim whitespace from company names:**
  ```sql
  UPDATE layoffs_staging2
  SET company = TRIM(company);
  ```

- **Standardize industry names:**
  ```sql
  UPDATE layoffs_staging2
  SET industry = 'Crypto'
  WHERE industry LIKE 'Crypto%';
  ```

- **Remove trailing periods from country names:**
  ```sql
  UPDATE layoffs_staging2
  SET country = TRIM(TRAILING '.' FROM country)
  WHERE country LIKE 'United States%';
  ```

- **Change `date` column data type:**
  ```sql
  UPDATE layoffs_staging2
  SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

  ALTER TABLE layoffs_staging2
  MODIFY COLUMN `date` DATE;
  ```

### 3. Handle Null Values

- **Delete rows where `total_laid_off` and `percentage_laid_off` are NULL:**
  ```sql
  DELETE FROM layoffs_staging2
  WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;
  ```

- **Impute missing industry data:**
  ```sql
  UPDATE layoffs_staging2 t1
  JOIN layoffs_staging2 t2
  ON t1.company = t2.company
  SET t1.industry = t2.industry
  WHERE t1.industry IS NULL
  AND t2.industry IS NOT NULL;
  ```

### 4. Remove Unnecessary Columns

- **Drop `row_num` column:**
  ```sql
  ALTER TABLE layoffs_staging2
  DROP COLUMN row_num;
  ```

## Final Cleaned Data

The cleaned data is stored in the `layoffs_staging2` table, which now contains standardized and duplicate-free records, with missing values handled appropriately.

## How to Run the Project

1. **Clone the repository:**
    ```bash
    git clone https://github.com/krystalbrantley/data-analyst-portfolio.git
    cd data-analyst-portfolio/world-layoffs-data-analysis
    ```

2. **Set up the database and import data:**
    - Import the `layoffs.csv` file into your MySQL database.
    - Run the SQL script `world_layoffs_data_cleaning.sql` to create the necessary tables and perform data cleaning

3. **Run the analysis:**
    Execute the SQL script `world_layoffs_eda.sql` to generate insights from the cleaned data.

## Conclusion

By thoroughly cleaning and standardizing the World Layoffs dataset, this project demonstrates the effectiveness of SQL in preparing data for meaningful analysis. The resulting insights can provide valuable information on global layoff trends and patterns.

## Contact Information

For any questions or further information, please feel free to contact me:

- **LinkedIn:** [My LinkedIn Profile](https://www.linkedin.com/in/krystalbrantley)


Thank you for reviewing this project!
