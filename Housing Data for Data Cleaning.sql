-- Cleaning Data in SQL Queries

SELECT *
FROM PortfolioProject.dbo.TorontoHousing 


-- Standardize Date Format


ALTER TABLE TorontoHousing
ADD SaleDate2 Date;

UPDATE TorontoHousing
SET SaleDate2 = CONVERT(Date, SaleDate)

SELECT SaleDate2
FROM PortfolioProject.dbo.TorontoHousing 


-- Populate Property Address Data


SELECT * 
FROM PortfolioProject.dbo.TorontoHousing
-- WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM PortfolioProject.dbo.TorontoHousing a
JOIN PortfolioProject.dbo.TorontoHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.TorontoHousing a
JOIN PortfolioProject.dbo.TorontoHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a 
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.TorontoHousing a
JOIN PortfolioProject.dbo.TorontoHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


-- Breaking out address into individual Columns (Address, city, state)


SELECT PropertyAddress
FROM PortfolioProject.dbo.TorontoHousing

SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress)) AS Address
FROM PortfolioProject.dbo.TorontoHousing    

ALTER TABLE PortfolioProject.dbo.TorontoHousing
ADD PropertySplitAddress Nvarchar(225);

UPDATE PortfolioProject.dbo.TorontoHousing 
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)

ALTER TABLE PortfolioProject.dbo.TorontoHousing
ADD PropertySplitCity Nvarchar(225);

UPDATE PortfolioProject.dbo.TorontoHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress))


SELECT *
FROM PortfolioProject.dbo.TorontoHousing

SELECT OwnerAddress
FROM PortfolioProject.dbo.TorontoHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) 
, PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 2) 
, PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 1) 
FROM PortfolioProject.dbo.TorontoHousing

ALTER TABLE PortfolioProject.dbo.TorontoHousing
ADD OwnerSplitAddress Nvarchar(225);

UPDATE PortfolioProject.dbo.TorontoHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE PortfolioProject.dbo.TorontoHousing
ADD OwnerSplitState Nvarchar(225);

UPDATE PortfolioProject.dbo.TorontoHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE PortfolioProject.dbo.TorontoHousing
ADD OwnerSplitCity Nvarchar(225);

UPDATE PortfolioProject.dbo.TorontoHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

SELECT *
FROM PortfolioProject.dbo.TorontoHousing



-- Change Y and N to Yes and No in "Sold As Vacant" field

SELECT DISTINCT (SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject.dbo.TorontoHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant 
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM PortfolioProject.dbo.TorontoHousing

UPDATE PortfolioProject.dbo.TorontoHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END



-- Remove Duplicates

WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
					UniqueID
					) row_num

FROM PortfolioProject.dbo.TorontoHousing
)
DELETE
FROM RowNumCTE
WHERE row_num > 1


-- Delete Unused Columns

ALTER TABLE PortfolioProject.dbo.TorontoHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress 

ALTER TABLE PortfolioProject.dbo.TorontoHousing
DROP COLUMN SaleDate

SELECT*
FROM PortfolioProject.dbo.TorontoHousing