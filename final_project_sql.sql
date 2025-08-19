
create database sql_project

-- 1. Customers
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(150) NOT NULL,
    DOB DATE,
    Email NVARCHAR(100) UNIQUE,
    PhoneNumber NVARCHAR(20),
    Address NVARCHAR(250),
    NationalID NVARCHAR(50),
    TaxID NVARCHAR(50),
    EmploymentStatus NVARCHAR(50),
    AnnualIncome DECIMAL(18,2),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME
);

-- 4. Branches
CREATE TABLE Branches (
    BranchID INT PRIMARY KEY IDENTITY(1,1),
    BranchName NVARCHAR(100),
    Address NVARCHAR(200),
    City NVARCHAR(100),
    State NVARCHAR(100),
    Country NVARCHAR(100),
    ManagerID INT,
    ContactNumber NVARCHAR(20)
);

-- 5. Employees
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    BranchID INT,
    FullName NVARCHAR(150) NOT NULL,
    Position NVARCHAR(100),
    Department NVARCHAR(100),
    Salary DECIMAL(18,2),
    HireDate DATE,
    Status NVARCHAR(20),
    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);

-- 2. Accounts
CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    AccountType NVARCHAR(50) CHECK (AccountType IN ('Savings','Checking','Business')),
    Balance DECIMAL(18,2) DEFAULT 0,
    Currency NVARCHAR(10),
    Status NVARCHAR(20),
    BranchID INT,
    CreatedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);

-- 3. Transactions
CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY IDENTITY(1,1),
    AccountID INT NOT NULL,
    TransactionType NVARCHAR(50) CHECK (TransactionType IN ('Deposit','Withdrawal','Transfer','Payment')),
    Amount DECIMAL(18,2) NOT NULL,
    Currency NVARCHAR(10),
    Date DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(20),
    ReferenceNo NVARCHAR(100),
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);


-- 6. CreditCards
CREATE TABLE CreditCards (
    CardID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    CardNumber NVARCHAR(20) UNIQUE,
    CardType NVARCHAR(50),
    CVV NVARCHAR(10),
    ExpiryDate DATE,
    LimitAmount DECIMAL(18,2),
    Status NVARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- 7. CreditCardTransactions
CREATE TABLE CreditCardTransactions (
    TransactionID INT PRIMARY KEY IDENTITY(1,1),
    CardID INT NOT NULL,
    Merchant NVARCHAR(150),
    Amount DECIMAL(18,2),
    Currency NVARCHAR(10),
    Date DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(20),
    FOREIGN KEY (CardID) REFERENCES CreditCards(CardID)
);

-- 8. OnlineBankingUsers
CREATE TABLE OnlineBankingUsers (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    Username NVARCHAR(50) UNIQUE,
    PasswordHash NVARCHAR(250),
    LastLogin DATETIME,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
-- 9. BillPayments
CREATE TABLE BillPayments (
    PaymentID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    BillerName NVARCHAR(150),
    Amount DECIMAL(18,2),
    Date DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- 10. MobileBankingTransactions
CREATE TABLE MobileBankingTransactions (
    TransactionID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    DeviceID NVARCHAR(100),
    AppVersion NVARCHAR(50),
    TransactionType NVARCHAR(50),
    Amount DECIMAL(18,2),
    Date DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);


-- 11. Loans
CREATE TABLE Loans (
    LoanID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    LoanType NVARCHAR(50),
    Amount DECIMAL(18,2),
    InterestRate DECIMAL(5,2),
    StartDate DATE,
    EndDate DATE,
    Status NVARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- 12. LoanPayments
CREATE TABLE LoanPayments (
    PaymentID INT PRIMARY KEY IDENTITY(1,1),
    LoanID INT NOT NULL,
    AmountPaid DECIMAL(18,2),
    PaymentDate DATE,
    RemainingBalance DECIMAL(18,2),
    FOREIGN KEY (LoanID) REFERENCES Loans(LoanID)
);

-- 13. CreditScores
CREATE TABLE CreditScores (
    CustomerID INT PRIMARY KEY,
    CreditScore INT,
    UpdatedAt DATETIME,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- 14. DebtCollection
CREATE TABLE DebtCollection (
    DebtID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    AmountDue DECIMAL(18,2),
    DueDate DATE,
    CollectorAssigned NVARCHAR(100),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);


-- 15. KYC
CREATE TABLE KYC (
    KYCID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    DocumentType NVARCHAR(50),
    DocumentNumber NVARCHAR(100),
    VerifiedBy NVARCHAR(100),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- 16. FraudDetection
CREATE TABLE FraudDetection (
    FraudID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    TransactionID INT,
    RiskLevel NVARCHAR(50),
    ReportedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (TransactionID) REFERENCES Transactions(TransactionID)
);

-- 17. AMLCases
CREATE TABLE AMLCases (
    CaseID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    CaseType NVARCHAR(50),
    Status NVARCHAR(50),
    InvestigatorID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (InvestigatorID) REFERENCES Employees(EmployeeID)
);

-- 18. RegulatoryReports
CREATE TABLE RegulatoryReports (
    ReportID INT PRIMARY KEY IDENTITY(1,1),
    ReportType NVARCHAR(100),
    SubmissionDate DATE
);


-- 19. Departments
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY IDENTITY(1,1),
    DepartmentName NVARCHAR(100),
    ManagerID INT
);

-- 20. Salaries
CREATE TABLE Salaries (
    SalaryID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeID INT NOT NULL,
    BaseSalary DECIMAL(18,2),
    Bonus DECIMAL(18,2),
    Deductions DECIMAL(18,2),
    PaymentDate DATE,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

-- 21. EmployeeAttendance
CREATE TABLE EmployeeAttendance (
    AttendanceID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeID INT NOT NULL,
    CheckInTime DATETIME,
    CheckOutTime DATETIME,
    TotalHours DECIMAL(5,2),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);


-- 22. Investments
CREATE TABLE Investments (
    InvestmentID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    InvestmentType NVARCHAR(50),
    Amount DECIMAL(18,2),
    ROI DECIMAL(5,2),
    MaturityDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- 23. StockTradingAccounts
CREATE TABLE StockTradingAccounts (
    AccountID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    BrokerageFirm NVARCHAR(100),
    TotalInvested DECIMAL(18,2),
    CurrentValue DECIMAL(18,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- 24. ForeignExchange
CREATE TABLE ForeignExchange (
    FXID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    CurrencyPair NVARCHAR(20),
    ExchangeRate DECIMAL(18,6),
    AmountExchanged DECIMAL(18,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);


-- 25. InsurancePolicies
CREATE TABLE InsurancePolicies (
    PolicyID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    InsuranceType NVARCHAR(50),
    PremiumAmount DECIMAL(18,2),
    CoverageAmount DECIMAL(18,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- 26. Claims
CREATE TABLE Claims (
    ClaimID INT PRIMARY KEY IDENTITY(1,1),
    PolicyID INT NOT NULL,
    ClaimAmount DECIMAL(18,2),
    Status NVARCHAR(50),
    FiledDate DATE,
    FOREIGN KEY (PolicyID) REFERENCES InsurancePolicies(PolicyID)
);

-- 27. UserAccessLogs
CREATE TABLE UserAccessLogs (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    ActionType NVARCHAR(100),
    Timestamp DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES OnlineBankingUsers(UserID)
);

-- 28. CyberSecurityIncidents
CREATE TABLE CyberSecurityIncidents (
    IncidentID INT PRIMARY KEY IDENTITY(1,1),
    AffectedSystem NVARCHAR(100),
    ReportedDate DATETIME DEFAULT GETDATE(),
    ResolutionStatus NVARCHAR(50)
);


-- 29. Merchants
CREATE TABLE Merchants (
    MerchantID INT PRIMARY KEY IDENTITY(1,1),
    MerchantName NVARCHAR(150),
    Industry NVARCHAR(100),
    Location NVARCHAR(150),
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- 30. MerchantTransactions
CREATE TABLE MerchantTransactions (
    TransactionID INT PRIMARY KEY IDENTITY(1,1),
    MerchantID INT NOT NULL,
    Amount DECIMAL(18,2),
    PaymentMethod NVARCHAR(50),
    Date DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (MerchantID) REFERENCES Merchants(MerchantID)
);


-----------------------------------------------------
-- Customers 
-----------------------------------------------------
DECLARE @Customers INT = 10000;

INSERT INTO Customers
(FullName, DOB, Email, PhoneNumber, Address, NationalID, TaxID, EmploymentStatus, AnnualIncome, CreatedAt, UpdatedAt)
SELECT TOP (@Customers)
    CONCAT('Customer ', n),
    DATEADD(DAY, -((18*365) + (ABS(CHECKSUM(NEWID())) % (62*365))), GETDATE()),
    CONCAT('user', n, '@example.com'),
    CONCAT('+1', RIGHT('0000000000' + CAST(n AS VARCHAR(10)), 10)),
    CONCAT(ABS(CHECKSUM(NEWID())) % 9999, ' Elm St, City ', (n % 400) + 1),
    RIGHT(CAST(ABS(CHECKSUM(NEWID())) AS VARCHAR(20)), 12), -- To‘g‘rilangan
    CAST(100000 + (n % 900000) AS NVARCHAR(20)),
    CHOOSE(n % 4 + 1, 'Employed','Self-Employed','Unemployed','Student'),
    5000 + (ABS(CHECKSUM(NEWID())) % 200000),
    DATEADD(DAY, -ABS(CHECKSUM(NEWID()) % 1000), GETDATE()),
    GETDATE()
FROM (
    SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) n
    FROM sys.all_objects a CROSS JOIN sys.all_objects b
) s;


-----------------------------------------------------
-- Branches 
-----------------------------------------------------
INSERT INTO Branches
(BranchName, Address, City, State, Country, ManagerID, ContactNumber)
SELECT TOP (100)
    CONCAT('Branch ', n),
    CONCAT(n, ' Main St'),
    CONCAT('City ', (n % 50) + 1),
    CONCAT('State ', (n % 20) + 1),
    'Uzbekistan',
    NULL,
    CONCAT('+99871', RIGHT('000000' + CAST(n AS VARCHAR(6)), 6))
FROM (
    SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) n
    FROM sys.all_objects
) s;


-----------------------------------------------------
-- Employees 
-----------------------------------------------------
INSERT INTO Employees
(BranchID, FullName, Position, Department, Salary, HireDate, Status)
SELECT TOP (2000)
    (n % 100) + 1, -- BranchID between 1–100
    CONCAT('Employee ', n),
    CHOOSE(n % 5 + 1, 'Manager','Teller','Analyst','IT','HR'),
    CHOOSE(n % 4 + 1, 'Operations','Finance','Support','Compliance'),
    300 + (ABS(CHECKSUM(NEWID())) % 2000) * 10,
    DATEADD(DAY, -ABS(CHECKSUM(NEWID()) % 3000), GETDATE()),
    CHOOSE(n % 2 + 1, 'Active','Inactive')
FROM (
    SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) n
    FROM sys.all_objects a CROSS JOIN sys.all_objects b
) s;


-----------------------------------------------------
-- Accounts 
-----------------------------------------------------
DECLARE @RowCount INT = 10000;
INSERT INTO Accounts
(CustomerID, AccountType, Balance, Currency, Status, BranchID, CreatedDate)
SELECT TOP (15000)
    (n % @RowCount) + 1,
    CHOOSE(n % 3 + 1, 'Savings','Checking','Business'),
    ABS(CHECKSUM(NEWID())) % 1000000,
    CHOOSE(n % 3 + 1, 'USD','UZS','EUR'),
    CHOOSE(n % 2 + 1, 'Active','Closed'),
    (n % 100) + 1,
    DATEADD(DAY, -ABS(CHECKSUM(NEWID()) % 2000), GETDATE())
FROM (
    SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) n
    FROM sys.all_objects a CROSS JOIN sys.all_objects b
) s;


-----------------------------------------------------
-- Loans 
-----------------------------------------------------
DECLARE @RowCount INT = 10000;
INSERT INTO Loans
(CustomerID, LoanType, Amount, InterestRate, StartDate, EndDate, Status)
SELECT TOP (8000)
    (n % @RowCount) + 1,
    CHOOSE(n % 4 + 1, 'Mortgage','Personal','Auto','Business'),
    1000 + (ABS(CHECKSUM(NEWID())) % 100000),
    (ABS(CHECKSUM(NEWID())) % 20) + 1,
    DATEADD(DAY, -ABS(CHECKSUM(NEWID()) % 3000), GETDATE()),
    DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 2000, GETDATE()),
    CHOOSE(n % 3 + 1, 'Active','Closed','Defaulted')
FROM (
    SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) n
    FROM sys.all_objects a CROSS JOIN sys.all_objects b
) s;


-----------------------------------------------------
-- Transactions 
-----------------------------------------------------
INSERT INTO Transactions
(AccountID, TransactionType, Amount, Currency, Date, Status, ReferenceNo)
SELECT TOP (50000)
    (n % 15000) + 1,
    CHOOSE(n % 4 + 1, 'Deposit','Withdrawal','Transfer','Payment'),
    ABS(CHECKSUM(NEWID())) % 10000,
    CHOOSE(n % 3 + 1, 'USD','UZS','EUR'),
    DATEADD(MINUTE, -ABS(CHECKSUM(NEWID()) % 1440000), GETDATE()),
    CHOOSE(n % 2 + 1, 'Completed','Pending'),
    CONCAT('TXN', n, ABS(CHECKSUM(NEWID())) % 10000)
FROM (
    SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) n
    FROM sys.all_objects a CROSS JOIN sys.all_objects b
) s;


select * from Accounts
-------------------------
--7. CreditCards
-------------------------
INSERT INTO CreditCards (CustomerID, CardNumber, CardType, CVV, ExpiryDate, LimitAmount, Status)
SELECT TOP 10000
    ABS(CHECKSUM(NEWID())) % 10000 + 1, -- random CustomerID
    CAST(ABS(CHECKSUM(NEWID())) % 10000000000000000 AS VARCHAR(16)),
    CASE WHEN RAND(CHECKSUM(NEWID())) > 0.5 THEN 'Visa' ELSE 'MasterCard' END,
    RIGHT('000' + CAST(ABS(CHECKSUM(NEWID())) % 999 AS VARCHAR(3)), 3),
    DATEADD(MONTH, ABS(CHECKSUM(NEWID())) % 60, GETDATE()), -- 5 yil ichida expiry
    ABS(CHECKSUM(NEWID())) % 20000 + 1000, -- limit 1000–21000
    CASE WHEN RAND(CHECKSUM(NEWID())) > 0.2 THEN 'Active' ELSE 'Blocked' END
FROM sys.objects a CROSS JOIN sys.objects b;

----------------------------
--8. OnlineBankingUsers
----------------------------
INSERT INTO OnlineBankingUsers (CustomerID, Username, PasswordHash, LastLogin)
SELECT TOP 10000
    ABS(CHECKSUM(NEWID())) % 10000 + 1,
    CONCAT('user', ROW_NUMBER() OVER (ORDER BY (SELECT NULL))),  -- всегда уникально
    CONVERT(VARCHAR(64), NEWID()),
    DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 365, GETDATE())
FROM sys.objects a CROSS JOIN sys.objects b;



select * from OnlineBankingUsers
-----------------------------------------
-- 9.BillPayments
------------------------------------
INSERT INTO BillPayments (CustomerID, BillerName, Amount, Date, Status)
SELECT TOP 10000
    ABS(CHECKSUM(NEWID())) % 10000 + 1,                                -- случайный CustomerID
    CHOOSE(ABS(CHECKSUM(NEWID())) % 5 + 1,                             -- случайный биллер
           'Electricity', 'Water', 'Gas', 'Internet', 'Mobile'),
    ABS(CHECKSUM(NEWID())) % 500000 / 100.0,                           -- сумма до 5000
    DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 365, GETDATE()),            -- дата в пределах 1 года
    CASE WHEN RAND(CHECKSUM(NEWID())) > 0.1 THEN 'Completed' ELSE 'Failed' END
FROM sys.objects a CROSS JOIN sys.objects b;


select * from BillPayments
------------------------------------------
-- 10.MobileBankingTransactions
------------------------------------------
INSERT INTO MobileBankingTransactions (CustomerID, DeviceID, AppVersion, TransactionType, Amount, Date)
SELECT TOP 10000
    ABS(CHECKSUM(NEWID())) % 10000 + 1, -- CustomerID (1–10000 orasida)
    CONCAT('Device-', ABS(CHECKSUM(NEWID())) % 100000), -- random DeviceID
    CONCAT('v', (ABS(CHECKSUM(NEWID())) % 5 + 1), '.', (ABS(CHECKSUM(NEWID())) % 10)), -- AppVersion v1.x–v5.x
    CHOOSE(ABS(CHECKSUM(NEWID())) % 4 + 1, 'Transfer', 'Payment', 'TopUp', 'Withdrawal'), -- 4 xil transaction
    CAST(ROUND(RAND(CHECKSUM(NEWID())) * 1000, 2) AS DECIMAL(18,2)), -- 0–1000 gacha summa
    DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 365, GETDATE()) -- oxirgi 1 yil ichida
FROM sys.all_objects a
CROSS JOIN sys.all_objects b;


select * from MobileBankingTransactions
---------------------------------------
--11. Loans 
---------------------------------------
INSERT INTO Loans (CustomerID, LoanType, Amount, InterestRate, StartDate, EndDate, Status)
SELECT TOP (10000)
    c.CustomerID,
    CHOOSE(ABS(CHECKSUM(NEWID())) % 5 + 1, 'Personal', 'Mortgage', 'Auto', 'Business', 'Education'),
    CAST(1000 + (ABS(CHECKSUM(NEWID())) % 100000) AS DECIMAL(18,2)),   -- 1k–100k
    CAST(3 + (ABS(CHECKSUM(NEWID())) % 15) AS DECIMAL(5,2)),           -- 3–18%
    DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 2000, GETDATE()),
    DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 2000, GETDATE()),
    CHOOSE(ABS(CHECKSUM(NEWID())) % 3 + 1, 'Active', 'Closed', 'Defaulted')
FROM Customers c
CROSS APPLY (SELECT TOP 2 1 AS x FROM sys.all_objects) t;
------------------------
--12. LoanPayments 
------------------------
INSERT INTO LoanPayments (LoanID, AmountPaid, PaymentDate, RemainingBalance)
SELECT TOP (10000)
    l.LoanID,
    CAST(100 + (ABS(CHECKSUM(NEWID())) % 5000) AS DECIMAL(18,2)),   -- 100–5100
    DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 1000, GETDATE()),
    CAST(500 + (ABS(CHECKSUM(NEWID())) % 50000) AS DECIMAL(18,2))   -- 500–50k
FROM Loans l
CROSS APPLY (SELECT TOP 3 1 AS x FROM sys.all_objects) t;
-------------------------------------
--13. CreditScores 
-------------------------------
INSERT INTO CreditScores (CustomerID, CreditScore, UpdatedAt)
SELECT TOP (10000)
    c.CustomerID,
    300 + ABS(CHECKSUM(NEWID())) % 550,   -- 300–850
    DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 365, GETDATE())
FROM Customers c
ORDER BY NEWID();
----------------------------
--14. DebtCollection 
----------------------------
INSERT INTO DebtCollection (CustomerID, AmountDue, DueDate, CollectorAssigned)
SELECT TOP (10000)
    c.CustomerID,
    CAST(500 + (ABS(CHECKSUM(NEWID())) % 20000) AS DECIMAL(18,2)),  -- 500–20k
    DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 365, GETDATE()),          -- 1 yilda ichida
    CHOOSE(ABS(CHECKSUM(NEWID())) % 5 + 1, 
           'Collector A', 'Collector B', 'Collector C', 'Collector D', 'Collector E')
FROM Customers c
CROSS APPLY (SELECT TOP 2 1 AS x FROM sys.all_objects) t;


-------------------------
-- 15. KYC
-------------------------
SET NOCOUNT ON;

INSERT INTO KYC (CustomerID, DocumentType, DocumentNumber, VerifiedBy)
SELECT TOP (10000)
    ABS(CHECKSUM(NEWID())) % 5000 + 1, -- CustomerID
    CASE ABS(CHECKSUM(NEWID())) % 3
        WHEN 0 THEN 'Passport'
        WHEN 1 THEN 'ID Card'
        ELSE 'Driver License'
    END,
    CONCAT('DOC-', ABS(CHECKSUM(NEWID())) % 900000 + 100000),
    CONCAT('Officer_', ABS(CHECKSUM(NEWID())) % 50 + 1)
FROM sys.all_objects a CROSS JOIN sys.all_objects b;

-------------------------
-- 16. FraudDetection
-------------------------
INSERT INTO FraudDetection (CustomerID, TransactionID, RiskLevel)
SELECT TOP (10000)
    ABS(CHECKSUM(NEWID())) % 5000 + 1, -- CustomerID
    ABS(CHECKSUM(NEWID())) % 8000 + 1, -- TransactionID (avval Transactions table to‘ldirilgan bo‘lishi kerak)
    CASE ABS(CHECKSUM(NEWID())) % 3
        WHEN 0 THEN 'Low'
        WHEN 1 THEN 'Medium'
        ELSE 'High'
    END
FROM sys.all_objects a CROSS JOIN sys.all_objects b;

-------------------------
-- 17. AMLCases
-------------------------
INSERT INTO AMLCases (CustomerID, CaseType, Status, InvestigatorID)
SELECT TOP (10000)
    ABS(CHECKSUM(NEWID())) % 5000 + 1, -- CustomerID
    CASE ABS(CHECKSUM(NEWID())) % 3
        WHEN 0 THEN 'Suspicious Transfer'
        WHEN 1 THEN 'Large Cash Deposit'
        ELSE 'Unusual Activity'
    END,
    CASE ABS(CHECKSUM(NEWID())) % 3
        WHEN 0 THEN 'Open'
        WHEN 1 THEN 'Closed'
        ELSE 'Pending'
    END,
    ABS(CHECKSUM(NEWID())) % 200 + 1 -- InvestigatorID (Employees tabledan)
FROM sys.all_objects a CROSS JOIN sys.all_objects b;

-------------------------
-- 18. RegulatoryReports
-------------------------
INSERT INTO RegulatoryReports (ReportType, SubmissionDate)
SELECT TOP (10000)
    CASE ABS(CHECKSUM(NEWID())) % 4
        WHEN 0 THEN 'AML Report'
        WHEN 1 THEN 'Fraud Report'
        WHEN 2 THEN 'KYC Compliance'
        ELSE 'Quarterly Audit'
    END,
    DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 365, GETDATE())
FROM sys.all_objects a CROSS JOIN sys.all_objects b;


-------------------------
-- 19. Departments
-------------------------
SET NOCOUNT ON;

INSERT INTO Departments (DepartmentName, ManagerID)
SELECT TOP (10000)
    CONCAT('Department_', ABS(CHECKSUM(NEWID())) % 200 + 1),
    ABS(CHECKSUM(NEWID())) % 2000 + 1 -- EmployeeID manager sifatida
FROM sys.all_objects a CROSS JOIN sys.all_objects b;
select * from Departments
-------------------------
-- 20. Salaries
-------------------------

INSERT INTO Salaries (EmployeeID, BaseSalary, Bonus, Deductions, PaymentDate)
SELECT TOP (10000)
    e.EmployeeID,
    CAST(30000 + (ABS(CHECKSUM(NEWID())) % 120000) AS DECIMAL(18,2)), -- base salary
    CAST(1000 + (ABS(CHECKSUM(NEWID())) % 20000) AS DECIMAL(18,2)),   -- bonus
    CAST(500 + (ABS(CHECKSUM(NEWID())) % 5000) AS DECIMAL(18,2)),    -- deductions
    DATEADD(MONTH, -ABS(CHECKSUM(NEWID())) % 36, GETDATE())          -- random last 3 years
FROM Employees e
CROSS APPLY (SELECT TOP 2 1 AS x FROM sys.all_objects) t; -- har bir Employee uchun 2 row

select * from Salaries

-------------------------
-- 21. EmployeeAttendance
-------------------------
INSERT INTO EmployeeAttendance (EmployeeID, CheckInTime, CheckOutTime, TotalHours)
SELECT TOP (10000)
    e.EmployeeID,
    DATEADD(HOUR, (ABS(CHECKSUM(NEWID())) % 2) + 8,  -- check-in: 8–9 AM
        DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 365, GETDATE())),
    DATEADD(HOUR, (ABS(CHECKSUM(NEWID())) % 3) + 17, -- check-out: 17–19 PM
        DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 365, GETDATE())),
    CAST((8 + (ABS(CHECKSUM(NEWID())) % 3)) AS DECIMAL(5,2)) -- 8–10 hours
FROM Employees e
CROSS APPLY (SELECT TOP 2 1 AS x FROM sys.all_objects) t; -- har bir Employee uchun 2 row
----------------------------------
--22 .Populate Investments 
---------------------------------
INSERT INTO Investments (CustomerID, InvestmentType, Amount, ROI, MaturityDate)
SELECT TOP (10000)
    c.CustomerID,
    CHOOSE(ABS(CHECKSUM(NEWID())) % 5 + 1, 'Bonds','Mutual Funds','Real Estate','Stocks','ETF'),
    CAST(1000 + (ABS(CHECKSUM(NEWID())) % 50000) AS DECIMAL(18,2)),  -- 1k–50k
    CAST((1 + (ABS(CHECKSUM(NEWID())) % 15)) AS DECIMAL(5,2)),       -- ROI 1–15%
    DATEADD(MONTH, (ABS(CHECKSUM(NEWID())) % 60) + 6, GETDATE())     -- maturity 6–60 months
FROM Customers c
CROSS APPLY (SELECT TOP 2 1 AS x FROM sys.all_objects) t;  -- har bir Customer uchun 2 ta row
------------------------------------
--23.Populate StockTradingAccounts 
------------------------------------
INSERT INTO StockTradingAccounts (CustomerID, BrokerageFirm, TotalInvested, CurrentValue)
SELECT TOP (10000)
    c.CustomerID,
    CHOOSE(ABS(CHECKSUM(NEWID())) % 4 + 1, 'Goldman Sachs','Morgan Stanley','Interactive Brokers','Robinhood'),
    CAST(2000 + (ABS(CHECKSUM(NEWID())) % 100000) AS DECIMAL(18,2)),  -- 2k–100k invested
    CAST(2000 + (ABS(CHECKSUM(NEWID())) % 120000) AS DECIMAL(18,2))   -- 2k–120k current
FROM Customers c
CROSS APPLY (SELECT TOP 2 1 AS x FROM sys.all_objects) t;  -- har bir Customer uchun 2 ta row
--------------------------------
--24.Populate ForeignExchange 
--------------------------------
INSERT INTO ForeignExchange (CustomerID, CurrencyPair, ExchangeRate, AmountExchanged)
SELECT TOP (10000)
    c.CustomerID,
    CHOOSE(ABS(CHECKSUM(NEWID())) % 6 + 1,
           'USD/EUR','USD/GBP','USD/JPY','EUR/JPY','GBP/CHF','AUD/USD'),
    CAST(0.5 + (ABS(CHECKSUM(NEWID())) % 150) / 10.0 AS DECIMAL(18,6)),   -- kurs 0.5–15.0 oralig‘ida
    CAST(100 + (ABS(CHECKSUM(NEWID())) % 50000) AS DECIMAL(18,2))        -- miqdor 100–50,000
FROM Customers c
CROSS APPLY (SELECT TOP 2 1 AS x FROM sys.all_objects) t;  -- har bir Customer uchun 2 ta row

--------------------------
--25. InsurancePolicies 
--------------------------

INSERT INTO InsurancePolicies (CustomerID, InsuranceType, PremiumAmount, CoverageAmount)
SELECT TOP (10000)
    c.CustomerID,
    CHOOSE(ABS(CHECKSUM(NEWID())) % 5 + 1, 'Health', 'Life', 'Car', 'Home', 'Travel'),
    CAST(100 + (ABS(CHECKSUM(NEWID())) % 5000) AS DECIMAL(18,2)),   -- Premium 100–5100
    CAST(10000 + (ABS(CHECKSUM(NEWID())) % 100000) AS DECIMAL(18,2)) -- Coverage 10k–110k
FROM Customers c
CROSS APPLY (SELECT TOP 2 1 AS x FROM sys.all_objects) t;
--------------------
--26. Claims 
--------------------

INSERT INTO Claims (PolicyID, ClaimAmount, Status, FiledDate)
SELECT TOP (10000)
    p.PolicyID,
    CAST(500 + (ABS(CHECKSUM(NEWID())) % 20000) AS DECIMAL(18,2)),   -- Claim 500–20k
    CHOOSE(ABS(CHECKSUM(NEWID())) % 3 + 1, 'Pending', 'Approved', 'Rejected'),
    DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 1000, GETDATE()) -- random date past 1000 days
FROM InsurancePolicies p
CROSS APPLY (SELECT TOP 2 1 AS x FROM sys.all_objects) t;
---------------------------
--27. UserAccessLogs 
---------------------------
INSERT INTO UserAccessLogs (UserID, ActionType, Timestamp)
SELECT TOP (10000)
    u.UserID,
    CHOOSE(ABS(CHECKSUM(NEWID())) % 4 + 1, 'Login', 'Logout', 'Password Change', 'Failed Login'),
    DATEADD(MINUTE, -ABS(CHECKSUM(NEWID())) % 100000, GETDATE())
FROM OnlineBankingUsers u
CROSS APPLY (SELECT TOP 3 1 AS x FROM sys.all_objects) t;
---------------------------------
--28. CyberSecurityIncidents 
---------------------------------
INSERT INTO CyberSecurityIncidents (AffectedSystem, ReportedDate, ResolutionStatus)
SELECT TOP (10000)
    CHOOSE(ABS(CHECKSUM(NEWID())) % 5 + 1, 'Core Banking', 'Mobile App', 'ATM Network', 'Online Portal', 'Internal Server'),
    DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 2000, GETDATE()),
    CHOOSE(ABS(CHECKSUM(NEWID())) % 3 + 1, 'Open', 'Investigating', 'Resolved')
FROM sys.all_objects a CROSS JOIN sys.all_objects b;
--------------------
--29. Merchants 
--------------------
INSERT INTO Merchants (MerchantName, Industry, Location, CustomerID)
SELECT TOP (10000)
    'Merchant_' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS NVARCHAR),
    CHOOSE(ABS(CHECKSUM(NEWID())) % 6 + 1, 'Retail', 'Food', 'Electronics', 'Clothing', 'Travel', 'Healthcare'),
    CHOOSE(ABS(CHECKSUM(NEWID())) % 5 + 1, 'Tashkent', 'Samarkand', 'Bukhara', 'Andijan', 'Namangan'),
    c.CustomerID
FROM Customers c
CROSS APPLY (SELECT TOP 2 1 AS x FROM sys.all_objects) t;
----------------------------
--30. MerchantTransactions 
----------------------------
INSERT INTO MerchantTransactions (MerchantID, Amount, PaymentMethod, Date)
SELECT TOP (10000)
    m.MerchantID,
    CAST(50 + (ABS(CHECKSUM(NEWID())) % 5000) AS DECIMAL(18,2)), -- 50–5050
    CHOOSE(ABS(CHECKSUM(NEWID())) % 4 + 1, 'Credit Card', 'Debit Card', 'Cash', 'Mobile Pay'),
    DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 1000, GETDATE())
FROM Merchants m
CROSS APPLY (SELECT TOP 3 1 AS x FROM sys.all_objects) t;


---------------------------
-- KPI's --
----------------------------
--	Top 3 Customers with the Highest Total Balance Across All Accounts 
SELECT TOP 3 
    c.CustomerID,
    c.FullName,
    SUM(a.Balance) AS TotalBalance
FROM Customers c
INNER JOIN Accounts a ON c.CustomerID = a.CustomerID
WHERE a.Status = 'Active'   -- faqat aktiv accountlarni olish mumkin
GROUP BY c.CustomerID, c.FullName
ORDER BY TotalBalance DESC;


-- Customers Who Have More Than One Active Loan

SELECT 
    c.CustomerID,
    c.FullName,
    COUNT(l.LoanID) AS ActiveLoanCount,
    SUM(l.Amount) AS TotalLoanAmount
FROM Customers c
INNER JOIN Loans l ON c.CustomerID = l.CustomerID
WHERE l.Status = 'Active'
GROUP BY c.CustomerID, c.FullName
HAVING COUNT(l.LoanID) > 1
ORDER BY ActiveLoanCount DESC, TotalLoanAmount DESC;


-- Fraudulent Transactions List
SELECT 
    t.TransactionID,
    t.AccountID,
    t.TransactionType,
    t.Amount,
    t.Currency,
    t.Date,
    t.Status,
    f.RiskLevel,
    f.ReportedDate,
    c.FullName AS CustomerName
FROM FraudDetection f
JOIN Transactions t 
    ON f.TransactionID = t.TransactionID
JOIN Customers c 
    ON f.CustomerID = c.CustomerID
ORDER BY f.ReportedDate DESC;

--	Total Loan Amount Issued Per Branch
SELECT 
    b.BranchID,
    b.BranchName,
    SUM(l.Amount) AS TotalLoanIssued
FROM Loans l
JOIN Customers c ON l.CustomerID = c.CustomerID
JOIN Accounts a ON c.CustomerID = a.CustomerID
JOIN Branches b ON a.BranchID = b.BranchID
GROUP BY b.BranchID, b.BranchName
ORDER BY TotalLoanIssued DESC;

--	Customers who made multiple large transactions (above $10,000) within a short time frame (less than 1 hour apart)
WITH LargeTx AS (
    SELECT 
        t.TransactionID,
        t.AccountID,
        a.CustomerID,
        t.Amount,
        t.Date,
        LAG(t.Date) OVER (PARTITION BY a.CustomerID ORDER BY t.Date) AS PrevDate,
        LAG(t.Amount) OVER (PARTITION BY a.CustomerID ORDER BY t.Date) AS PrevAmount
    FROM Transactions t
    INNER JOIN Accounts a ON t.AccountID = a.AccountID
)
SELECT 
    c.CustomerID,
    c.FullName,
    lt.TransactionID,
    lt.Amount,
    lt.Date,
    lt.PrevDate,
    DATEDIFF(MINUTE, lt.PrevDate, lt.Date) AS MinutesApart
FROM LargeTx lt
INNER JOIN Customers c ON lt.CustomerID = c.CustomerID
WHERE lt.PrevDate IS NOT NULL   -- чтобы была предыдущая транзакция
ORDER BY c.CustomerID, lt.Date;




-- Customers who have made transactions from different countries within 10 minutes
WITH TransactionPairs AS (
    SELECT 
        a.CustomerID,
        t1.TransactionID AS Transaction1ID,
        t2.TransactionID AS Transaction2ID,
        t1.Currency AS Country1,
        t2.Currency AS Country2,
        t1.Date AS Date1,
        t2.Date AS Date2,
        DATEDIFF(MINUTE, t1.Date, t2.Date) AS DiffMinutes
    FROM Transactions t1
    INNER JOIN Transactions t2
        ON t1.AccountID = t2.AccountID
       AND t1.TransactionID < t2.TransactionID
    INNER JOIN Accounts a
        ON t1.AccountID = a.AccountID
)
SELECT TOP 50
    CustomerID,
    Transaction1ID,
    Transaction2ID,
    Country1,
    Country2,
    Date1,
    Date2,
    DiffMinutes
FROM TransactionPairs
ORDER BY CustomerID, Date1;
