class Employee:
    def __init__(self, request):
        self.EID = request[0]
        self.Name = request[1]
        self.Address = request[2]
        self.Age = request[3]
        self.Gender = request[4]
        self.Aadhar = request[5]

class Post:
    def __init__(self, request):
        self.PID = request[1]
        self.UID = request[0]
        self.Name = request[2]
        self.Class = request[3]
        self.ULB = request[4]

class Salary:
    def __init__(self, request):
        self.SID = request[0]
        self.Basic_Pay = request[1]
        self.Grade_Pay = request[2]
        self.Total_Pay = request[1] + request[2]

class Dependents:
    def __init__(self, request):
        self.Aadhar = request[0]
        self.EID = request[1]
        self.Name = request[2]
        self.Address = request[3]
        self.Age = request[4]
        self.Gender = request[5]
        self.Relation = request[6]

class Charges:
    def __init__(self, request):
        self.EID = request[4]
        self.IID = request[0]
        self.Decision = request[1]
        self.Appeal = request[2]
        self.Charges = request[3]

class Contracts:
    def __init__(self, request, EID = None):
        self.CID = request[0]
        self.Contract = request[1]
        self.Salary = request[2]
        self.Date_Started = request[3]
        self.End_Date = request[4]
        self.ULB = request[5]
        if EID is not None:
            self.EID = EID

class Leaves:
    def __init__(self, request):
        self.EID = request[0]
        self.Date = str(request[1])
        self.Type = request[2]
        self.Approved = request[3]
        if len(request) > 4:
            self.Name = request[4]

class Loans:
    def __init__(self, request):
        self.LID = request[0]
        self.Amount = request[1]
        self.Date = str(request[2])
        self.Duration = request[3]
        self.Type = request[4]
        self.Status = request[5]
        self.Paid = request[6]

class Payments:
    def __init__(self, request, rates, city, loans):
        self.Account_No = request[0]
        self.IFSC = request[1]
        self.Date = str(request[2])
        self.Deductions = request[3]/1
        self.Base_Pay = request[4]
        self.Grade_Pay = request[5]
        Total_Pay_Month = self.Base_Pay + self.Grade_Pay
        Total_Pay_Year = Total_Pay_Month*12
        self.DA = (Total_Pay_Month * rates[1])/100
        if city == 'Corporation':
            self.House_Rent_Allowance = (Total_Pay_Month * rates[2])/100
        elif city == 'Council':
            self.House_Rent_Allowance = (Total_Pay_Month * rates[3])/100
        elif city == 'Committee':
            self.House_Rent_Allowance = (Total_Pay_Month * rates[4])/100
        else:
            self.House_Rent_Allowance = 0
        self.Medical_Allowance = rates[5]

        income_tax = rates[6].split(';')
        for i in range(len(income_tax)):
            income_tax[i] = income_tax[i].split(':')
            income_tax[i][1] = income_tax[i][1].split('+')
            income_tax[i][1][0] = int(income_tax[i][1][0])
            income_tax[i][1][1] = int(income_tax[i][1][1])
            for j in range(len(income_tax[i])):
                if j is not 1:
                    income_tax[i][j] = int(income_tax[i][j])

        if Total_Pay_Year > income_tax[0][0] and Total_Pay_Year < income_tax[0][2]:
            self.Income_Tax = (income_tax[0][1][0] + Total_Pay_Year*income_tax[0][1][1])/1200
        elif Total_Pay_Year > income_tax[1][0] and Total_Pay_Year < income_tax[1][2]:
            self.Income_Tax = (income_tax[1][1][0] + Total_Pay_Year*income_tax[1][1][1])/1200
        elif Total_Pay_Year > income_tax[2][0] and Total_Pay_Year < income_tax[2][2]:
            self.Income_Tax = ((income_tax[2][1][0] + Total_Pay_Year*income_tax[2][1][1])/1200)
        elif Total_Pay_Year > income_tax[3][0]:
            self.Income_Tax = ((income_tax[3][1][0] + Total_Pay_Year*income_tax[3][1][1])/1200)
        else:
            self.Income_Tax = 0
        self.Provident_Fund = (Total_Pay_Month * rates[8])/100
        self.GIS = rates[9]
        self.Loan_Recovery = 0
        for loan in loans:
            self.Loan_Recovery += (loan[0]*(100 + rates[7]))/(loan[1]*1200)
        self.Final_Salary = self.Base_Pay + self.Grade_Pay + self.DA + self.House_Rent_Allowance + self.Medical_Allowance - self.Income_Tax - self.Loan_Recovery - self.Provident_Fund - self.GIS - self.Deductions
        self.Loan_Recovery = float("{0:.2f}".format(self.Loan_Recovery))
        self.Final_Salary = float("{0:.2f}".format(self.Final_Salary))


class Orders:
    def __init__(self, request):
        self.EID = request[0]
        self.OID = request[1]
        self.Quantity = request[2]
        self.Item = request[3]
        self.Date = str(request[4])
        self.Approved = request[5]


class Employee_Posts:
    def __init__(self, request):
        self.EID = request[0]
        self.Name = request[1]
        self.PID = request[2]
        self.Post_Name = request[3]
        self.Age = request[4]
        self.Gender = request[5]
        self.Phone = request[6]

class Employee_Loans:
    def __init__(self, request):
        self.EID = request[0]
        self.LID = request[1]
        self.Amount = request[2]
        self.Date = str(request[3])
        self.Duration = request[4]
        self.Type = request[5]
        self.Status = request[6]
        self.E_Name = request[8]
        self.PID = request[9]
        self.UID = request[10]

class Employee_Contract:
    def __init__(self, request):
        self.EID = request[0]
        self.Name = request[1]
        self.Address = request[2]
        self.Age = request[3]
        self.Gender = request[4]
        self.Aadhar = request[5]
        self.Account_No = request[6]
        self.IFSC = request[7]
        self.Phone = request[8]

class Leaves_Contracts:
    def __init__(self, request):
        self.CID = request[1]
        self.EID = request[0]
        self.Date = str(request[2])
        self.Type = request[3]
        self.Approved = request[4]
        self.Name = request[5]

class Contract_Payment:
    def __init__(self, request, rates):
        self.CID = request[0]
        self.Account_No = request[1]
        self.IFSC = request[2]
        self.Date = str(request[3])
        self.Deductions = request[4]/1
        self.Salary = request[5]
        income_tax = rates.split(';')
        Total_Pay_Year = 12*self.Salary
        for i in range(len(income_tax)):
            income_tax[i] = income_tax[i].split(':')
            income_tax[i][1] = income_tax[i][1].split('+')
            income_tax[i][1][0] = int(income_tax[i][1][0])
            income_tax[i][1][1] = int(income_tax[i][1][1])
            for j in range(len(income_tax[i])):
                if j is not 1:
                    income_tax[i][j] = int(income_tax[i][j])
        
        if Total_Pay_Year > income_tax[0][0] and Total_Pay_Year < income_tax[0][2]:
            self.Income_Tax = (income_tax[0][1][0] + Total_Pay_Year*income_tax[0][1][1])/1200
        elif Total_Pay_Year > income_tax[1][0] and Total_Pay_Year < income_tax[1][2]:
            self.Income_Tax = (income_tax[1][1][0] + Total_Pay_Year*income_tax[1][1][1])/1200
        elif Total_Pay_Year > income_tax[2][0] and Total_Pay_Year < income_tax[2][2]:
            self.Income_Tax = ((income_tax[2][1][0] + Total_Pay_Year*income_tax[2][1][1])/1200)
        elif Total_Pay_Year > income_tax[3][0]:
            self.Income_Tax = ((income_tax[3][1][0] + Total_Pay_Year*income_tax[3][1][1])/1200)
        else:
            self.Income_Tax = 0
        self.Final_Salary = self.Salary - self.Deductions - self.Income_Tax

class Orders_Regular:
    def __init__(self, request):
        self.EID = request[0]
        self.Name = request[1]
        self.OID = request[2]
        self.Quantity = request[3]
        self.Item = request[4]
        self.Date = str(request[5])
        self.Approved = request[6]

class Orders_Contracts:
    def __init__(self, request):
        self.EID = request[0]
        self.Name = request[1]
        self.OID = request[2]
        self.Quantity = request[3]
        self.Item = request[4]
        self.CID = request[5]
        self.Date = str(request[6])
        self.Approved = request[7]

class Make_Payment:
    def __init__(self, request, rates, city, loans):
        self.EID = request[0]
        self.Name = request[1]
        self.Account_No = request[2]
        self.IFSC = request[3]
        self.SID = request[4]
        self.Base_Pay = request[5]
        self.Grade_Pay = request[6]
        Total_Pay_Month = self.Base_Pay + self.Grade_Pay
        Total_Pay_Year = Total_Pay_Month*12
        self.DA = (Total_Pay_Month * rates[1])/100
        if city == 'Corporation':
            self.House_Rent_Allowance = (Total_Pay_Month * rates[2])/100
        elif city == 'Council':
            self.House_Rent_Allowance = (Total_Pay_Month * rates[3])/100
        elif city == 'Committee':
            self.House_Rent_Allowance = (Total_Pay_Month * rates[4])/100
        else:
            self.House_Rent_Allowance = 0
        self.Medical_Allowance = rates[5]
        
        income_tax = rates[6].split(';')
        for i in range(len(income_tax)):
            income_tax[i] = income_tax[i].split(':')
            income_tax[i][1] = income_tax[i][1].split('+')
            income_tax[i][1][0] = int(income_tax[i][1][0])
            income_tax[i][1][1] = int(income_tax[i][1][1])
            for j in range(len(income_tax[i])):
                if j is not 1:
                    income_tax[i][j] = int(income_tax[i][j])

        if Total_Pay_Year > income_tax[0][0] and Total_Pay_Year < income_tax[0][2]:
            self.Income_Tax = (income_tax[0][1][0] + Total_Pay_Year*income_tax[0][1][1])/1200
        elif Total_Pay_Year > income_tax[1][0] and Total_Pay_Year < income_tax[1][2]:
            self.Income_Tax = (income_tax[1][1][0] + Total_Pay_Year*income_tax[1][1][1])/1200
        elif Total_Pay_Year > income_tax[2][0] and Total_Pay_Year < income_tax[2][2]:
            self.Income_Tax = ((income_tax[2][1][0] + Total_Pay_Year*income_tax[2][1][1])/1200)
        elif Total_Pay_Year > income_tax[3][0]:
            self.Income_Tax = ((income_tax[3][1][0] + Total_Pay_Year*income_tax[3][1][1])/1200)
        else:
            self.Income_Tax = 0
        self.Provident_Fund = (Total_Pay_Month * rates[8])/100
        self.GIS = rates[9]
        self.Loan_Recovery = 0
        self.LIDs = []
        self.Loans = []
        for loan in loans:
            self.Loan_Recovery += (loan[1]*(100 + rates[7]))/(loan[2]*1200)
            self.Loans.append((loan[1]*(100 + rates[7]))/(loan[2]*1200))
            self.LIDs.append(loan[0])
        self.Final_Salary = self.Base_Pay + self.Grade_Pay + self.DA + self.House_Rent_Allowance + self.Medical_Allowance - self.Income_Tax - self.Loan_Recovery - self.Provident_Fund - self.GIS
        self.Final_Salary = float("{0:.2f}".format(self.Final_Salary))

class Contract_Make_Payment:
    def __init__(self, request, rates):
        self.CID = request[0]
        self.EID = request[1]
        self.Name = request[2]
        self.Account_No = request[3]
        self.IFSC = request[4]
        self.Salary = request[5]
        income_tax = rates.split(';')
        Total_Pay_Year = 12*self.Salary
        for i in range(len(income_tax)):
            income_tax[i] = income_tax[i].split(':')
            income_tax[i][1] = income_tax[i][1].split('+')
            income_tax[i][1][0] = int(income_tax[i][1][0])
            income_tax[i][1][1] = int(income_tax[i][1][1])
            for j in range(len(income_tax[i])):
                if j is not 1:
                    income_tax[i][j] = int(income_tax[i][j])
        
        if Total_Pay_Year > income_tax[0][0] and Total_Pay_Year < income_tax[0][2]:
            self.Income_Tax = (income_tax[0][1][0] + Total_Pay_Year*income_tax[0][1][1])/1200
        elif Total_Pay_Year > income_tax[1][0] and Total_Pay_Year < income_tax[1][2]:
            self.Income_Tax = (income_tax[1][1][0] + Total_Pay_Year*income_tax[1][1][1])/1200
        elif Total_Pay_Year > income_tax[2][0] and Total_Pay_Year < income_tax[2][2]:
            self.Income_Tax = ((income_tax[2][1][0] + Total_Pay_Year*income_tax[2][1][1])/1200)
        elif Total_Pay_Year > income_tax[3][0]:
            self.Income_Tax = ((income_tax[3][1][0] + Total_Pay_Year*income_tax[3][1][1])/1200)
        else:
            self.Income_Tax = 0
        self.Final_Salary = self.Salary - self.Income_Tax

class Transfers:
    def __init__(self, request):
        self.init_post = request[0]
        self.init_ulb = request[1]
        self.final_post = request[2]
        self.final_ulb = request[3]
        self.relieving_date = request[4]
        self.joining_date = request[5]

class Demotions:
    def __init__(self, request):
        self.IID = request[0]
        self.init_post = request[1]
        self.init_ulb = request[2]
        self.final_post = request[3]
        self.final_ulb = request[4]
        self.relieving_date = request[5]
        self.joining_date = request[6]

