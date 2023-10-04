

Select *
From PortfolioProjects.dbo.nashvileHousing

---Standardize Date format

Select SaledateConverted, CONVERT(Date,Saledate)
From PortfolioProjects.dbo.nashvileHousing

Update nashvileHousing
Set Saledate = CONVERT(Date,Saledate)

ALTER TABLE nashvileHousing
Add SaleDateConverted Date;

Update nashvileHousing
Set SaledateConverted = CONVERT(Date,Saledate)

---POpulate Property Address Data

Select *
From PortfolioProjects.dbo.nashvileHousing
--Where PropertyAddress is NULL
Order by ParcelID

Select a.ParcelID, b.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProjects.dbo.nashvileHousing a
Join PortfolioProjects.dbo.nashvileHousing b
On a.ParcelID =b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is NULL

---Breaking out Address into individual columns (Address,City,State)

Select PropertyAddress
From PortfolioProjects.dbo.nashvileHousing
--Where PropertyAddress is NULL
--

SELECT
PARSENAME(REPLACE(PropertyAddress, ',', '.') ,2)
,PARSENAME(REPLACE(PropertyAddress, ',', '.') ,1)
From PortfolioProjects.dbo.nashvileHousing

ALTER TABLE nashvileHousing
Add PropertySplitAddress Nvarchar(255);

Update nashvileHousing
Set PropertySplitAddress = PARSENAME(REPLACE(PropertyAddress, ',', '.') ,2)

ALTER TABLE nashvileHousing
Add PropertySplitcity Nvarchar(255);

Update nashvileHousing
Set PropertySplitcity = PARSENAME(REPLACE(PropertyAddress, ',', '.') ,1)

Select *
From PortfolioProjects.dbo.nashvileHousing


Select OwnerAddress
From PortfolioProjects.dbo.nashvileHousing

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)
From PortfolioProjects.dbo.nashvileHousing

ALTER TABLE nashvileHousing
Add OwnerSplitAddress Nvarchar(255);

Update nashvileHousing
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)

ALTER TABLE nashvileHousing
Add OwnerSplitCity Nvarchar(255);

Update nashvileHousing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)

ALTER TABLE nashvileHousing
Add OwnerSplitState Nvarchar(255);

Update nashvileHousing
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)

Select *
From PortfolioProjects.dbo.nashvileHousing

---Change Y and N to Yes and No in ''Sold As Vacant'' Field

Select DISTINCT(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProjects.dbo.nashvileHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
,CASE When SoldAsVacant = 'Y' Then 'Yes'
     When SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant
	 End
From PortfolioProjects.dbo.nashvileHousing

Update nashvileHousing
Set SoldAsVacant = CASE When SoldAsVacant = 'Y' Then 'Yes'
     When SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant
	 End

	 --Remove Duplicates

Selet *,
    ROW_NUMBER() OVER (
    PARTITION BY ParcelID,
             PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 ORDER BY
			 UniqueID
			 ) row_num
From PortfolioProjects.dbo.nashvileHousing

---Deleting unused Table

Select *
From PortfolioProjects.dbo.nashvileHousing

ALTER TABLE PortfolioProjects.dbo.nashvileHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress





