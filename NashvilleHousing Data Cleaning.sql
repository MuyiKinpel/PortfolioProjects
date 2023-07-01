

--Cleaning Data in SQL Queries

Select *
From portfolioProject..NashvilleHousing

--Standardize Data Fromat

Select SaleDateConverted, CONVERT(Date, SaleDate)
From portfolioProject..NashvilleHousing


Update Nashvillehousing
SET SaleDate = CONVERT(Date, SaleDate)


Alter Table NashvilleHousing
Add SaleDateConverted Date


Update Nashvillehousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

--Populate Property Address Data

Select *
From PortfolioProject..NashvilleHousing
--where PropertyAddress is null
Order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
On a.ParcelID = b.ParcelID
And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
On a.ParcelID = b.ParcelID
And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

--Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From PortfolioProject..NashvilleHousing
--where PropertyAddress is null
--Order by ParcelID

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address
From PortfolioProject..NashvilleHousing


Alter table NashvilleHousing
Add PropertySplitAddress Nvarchar(255);


Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


Alter Table NashvilleHousing
Add PropertySplitCity Nvarchar(255);


Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))



Select *
From PortfolioProject..Nashvillehousing



Select OwnerAddress
From PortfolioProject..Nashvillehousing


Select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
From PortfolioProject..NashvilleHousing


Alter Table NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)


Alter Table NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update Nashvillehousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)


Alter Table NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


Select *
From PortfolioProject..NashvilleHousing


--Change Y and N to Yes and No in "Sold as Vacant" firld


Select Distinct(SoldASVacant), Count(SoldASVacant)
From PortfolioProject..NashvilleHousing
Group by SoldASVacant
Order by 2


Select SoldAsVacant,
CASE
	when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	ELSE SoldAsVacant
	END
From PortfolioProject..NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	ELSE SoldAsVacant
	END

--Remove Duplicate

WITH ROwNumCTE AS(
Select *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 LegalReference
				 ORDER BY
				    UniqueID
					)row_num
					
From PortfolioProject..NashvilleHousing
--Order by ParcelID
)
Select *
From ROwNumCTE
where row_num > 1
--Order by PropertyAddress

--Delete unused Columns

Select *
From PortfolioProject..NashvilleHousing

Alter table PortfolioProject..NashvilleHousing
Drop Column SaleDate