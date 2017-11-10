from django.contrib.auth.decorators import login_required
from django.shortcuts import get_object_or_404, render
from django.views import generic
from django.db import connection, transaction
from django.http import HttpResponseRedirect
from django.urls import reverse
from django.http import HttpResponse
from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login, logout
from . import classes
import datetime

class UserType:
    def __init__(self, request):
        if request[0] == 1:
            self.regularised = True
            self.contract_based = False
            self.head_of_ULB = False
            self.head_of_head = False
            self.ULB_admin = False
            self.ULB_Accountant = False
        
        elif request[0] == 2:
            self.regularised = True
            self.contract_based = False
            self.head_of_ULB = True
            self.head_of_head = False
            self.ULB_admin = False
            self.ULB_Accountant = False
        
        elif request[0] == 3:
            self.regularised = False
            self.contract_based = True
            self.head_of_ULB = False
            self.head_of_head = False
            self.ULB_admin = False
            self.ULB_Accountant = False
        
        elif request[0] == 4:
            self.regularised = True
            self.contract_based = False
            self.head_of_ULB = True
            self.head_of_head = True
            self.ULB_admin = False
            self.ULB_Accountant = False
        
        elif request[0] == 5:
            self.regularised = True
            self.contract_based = False
            self.head_of_ULB = False
            self.head_of_head = False
            self.ULB_admin = True
            self.ULB_Accountant = False
        
        elif request[0] == 6:
            self.regularised = True
            self.contract_based = False
            self.head_of_ULB = False
            self.head_of_head = False
            self.ULB_admin = False
            self.ULB_Accountant = True
        
        else:
            self.regularised = False
            self.contract_based = False
            self.head_of_ULB = False
            self.head_of_head = False
            self.ULB_admin = False
            self.ULB_Accountant = False


def get_user_type(request):
    with connection.cursor() as cursor:
        cursor.execute("select group_id from auth_user_groups where user_id = %s", [request.user.id])
        row = cursor.fetchall()
    return UserType(row[0])

def get_user_name(request):
    with connection.cursor() as cursor:
        cursor.execute("select name from employee as e inner join employee_login as e_l on e.eid = e_l.eid where user = %s", [request.user.id])
        row = cursor.fetchall()
    return row[0][0]
# Create your views here.

def log_in(request):
    if request.user.is_authenticated:
        return HttpResponseRedirect('/home/')
    if request.GET:
        next = request.GET.get('next')
        return render(request, 'login.html', {'next': next})
    else:
        return render(request, 'login.html')

def auth(request):
    if request.GET:
        print(request.GET)
    if 'username' and 'password' in request.POST:
        username = request.POST.get('username')
        password = request.POST.get('password')
        user = authenticate(username=username, password=password)
        if user is not None:
            login(request, user)
            with connection.cursor() as cursor:
                cursor.execute("select group_id from auth_user_groups where user_id = %s", [request.user.id])
                row = cursor.fetchall()
            user_type = UserType(row[0])
            if request.POST.get('next') != '':
                return HttpResponseRedirect(request.POST.get('next'))
            return HttpResponseRedirect('/home/')
        else:
            return render(request, 'login.html', {'auth_fail':True})
    else:
        return render(request, 'login.html')


@login_required(login_url="/login")
def home(request):
    user_type = get_user_type(request)
    name = get_user_name(request)
    post = dependents = salary = contract = None

    with connection.cursor() as cursor:
        cursor.execute("select eid, name, address, age, gender, aadhar from employee natural join employee_login where user = %s", [request.user.id])
        row = cursor.fetchall()
    employee = classes.Employee(row[0])

    with connection.cursor() as cursor:
        cursor.execute("select phone from employee_phone where EID = %s", [employee.EID])
        row = cursor.fetchall()
    employee_phone = []
    for number in row:
        employee_phone.append(number[0])

    if user_type.regularised:
        with connection.cursor() as cursor:
            cursor.execute("select pid, uid from employee_post where eid = %s", [employee.EID])
            row = cursor.fetchall()
            Employee_PID = row[0][0]
            Employee_UID = row[0][1]
            cursor.execute("select uid, pid, post_name, class, ulb_name from post natural join ulb where pid = %s and uid = %s", [Employee_PID, Employee_UID])
            row = cursor.fetchone()
        post = classes.Post(row)

        with connection.cursor() as cursor:
            cursor.execute("select sid, basic_pay, grade_pay from salary natural join pay_scale where eid = %s", [employee.EID])
            row = cursor.fetchall()
        salary = classes.Salary(row[0])

        with connection.cursor() as cursor:
            cursor.execute("select aadhar, eid, name, address, age, gender, relation from dependents where eid = %s", [employee.EID])
            rows = cursor.fetchall()
        dependents = []
        for row in rows:
            dependents.append(classes.Dependents(row))

    rows = []
    with connection.cursor() as cursor:
        cursor.execute("select iid, decision, appeal, charges, eid from charge_sheet natural join employee_charges where eid = %s", [employee.EID])
        rows = cursor.fetchall()
    charges = []
    for row in rows:
        charges.append(classes.Charges(row))
   
    rows = []
    if user_type.contract_based:
        with connection.cursor() as cursor:
            cursor.execute("select cid, contract, salary, date_started, end_date, ulb_name from contract_based natural join contracts natural join (select ulb_name, uid from ulb) as name_ulb where eid = %s", [employee.EID])
            rows = cursor.fetchone()
        contract = classes.Contracts(rows, None)

        with connection.cursor() as cursor:
            cursor.execute("select income_tax from rates where date = (select max(date) from rates where date < %s)", [str(datetime.datetime.today()).split(' ')[0]])
            rates = cursor.fetchone()[0]
            cursor.execute("select cid, account_no, ifsc, date, deductions, salary from contract_payment natural join contract_based natural join (select cid, salary from contracts) as contract_salary where eid = %s", [employee.EID])
            rows = cursor.fetchall()
    payments = []
    for row in rows:
        payments.append(classes.Contract_Payment(row, rates))

    return render(request, 'home.html', {'Name': name, 'UserType': user_type, 'employee': employee, 'post': post, 'salary': salary, 'dependents': dependents, 'employee_phone': employee_phone, 'charges': charges, 'contract': contract, 'payments': payments})


@login_required(login_url="/login")
def leave(request):
    user_type = get_user_type(request)
    name = get_user_name(request)
    year = datetime.datetime.today().year
    request_accepted = 0
    
    with connection.cursor() as cursor:
        cursor.execute("select eid from employee_login where user = %s", [request.user.id])
        Employee_ID = cursor.fetchone()[0]
    
    if 'submit_regular' in request.POST:
        with connection.cursor() as cursor:
            if user_type.head_of_head:
                cursor.execute("select eid, date, type, approved, name from leave_record natural join employee_post natural join (select eid, name from employee) as employee_name where (uid = (select uid from employee_post where eid = %s) or pid = 1) and approved = 'N' and date > '%s-1-1' and eid <> %s", [Employee_ID, year, Employee_ID])
                rows = cursor.fetchall()
            elif user_type.head_of_ULB:
                cursor.execute("select eid, date, type, approved, name from leave_record natural join employee_post natural join (select eid, name from employee) as employee_name where uid = (select uid from employee_post where eid = %s)  and approved = 'N' and date > '%s-1-1' and eid <> %s", [Employee_ID, year, Employee_ID])
                rows = cursor.fetchall()
        employee_leaves = []
        for row in rows:
            employee_leaves.append(classes.Leaves(row))

        for i in range(1, len(employee_leaves) + 1):
            key = request.POST.get(str(i))
            if key != None:
                key = key.split(';')
                date = key[1]
                if key[0][0] == '-':
                    eid = int(key[0][1:])
                    with connection.cursor() as cursor:
                        cursor.execute("update leave_record set approved = 'C' where eid = %s and date = %s", [eid, date])
                else:
                    eid = int(key[0])
                    with connection.cursor() as cursor:
                        cursor.execute("update leave_record set approved = 'Y' where eid = %s and date = %s", [eid, date])

    if 'submit_contract' in request.POST:
        with connection.cursor() as cursor:
            if user_type.head_of_ULB:
                cursor.execute("select eid, cid, date, type, approved, name from leave_record natural join contract_based natural join (select cid from contracts where uid = (select uid from employee_post where eid = %s)) as contracts_uid natural join (select eid, name from employee) as employee_name where approved = 'N' and date > '%s-1-1'", [Employee_ID, year])
                rows = cursor.fetchall()
        employee_leaves_contracts = []
        for row in rows:
            employee_leaves_contracts.append(classes.Leaves_Contracts(row))
        
        for i in range(1, len(employee_leaves_contracts) + 1):
            key = request.POST.get(str(-1*i))
            if key != None:
                key = key.split(';')
                date = key[1]
                if key[0][0] == '-':
                    eid = int(key[0][1:])
                    with connection.cursor() as cursor:
                        cursor.execute("update leave_record set approved = 'C' where eid = %s and date = %s", [eid, date])
                else:
                    eid = int(key[0])
                    with connection.cursor() as cursor:
                        cursor.execute("update leave_record set approved = 'Y' where eid = %s and date = %s", [eid, date])

    if 'date' in request.POST:
        Date = request.POST.get('date')
        Type = request.POST.get('type')
        flag = 0
        with transaction.atomic():
            with connection.cursor() as cursor:
                cursor.execute("select count(date) from leave_record where eid = %s and date > '%s-01-01' group by eid", [Employee_ID, year])
                row = cursor.fetchone()
                if row and row[0] > 10:
                    request_accepted = 3
                    flag = 1
                cursor.execute("select * from leave_record where eid = %s and date = %s", [Employee_ID, Date])
                if len(cursor.fetchall()) > 0:
                    request_accepted = 2
                    flag = 1
                if not flag:
                    if user_type.head_of_head:
                        cursor.execute("insert into leave_record values (%s, %s, %s, 'Y')", [Employee_ID, Date, Type])
                    else:
                        cursor.execute("insert into leave_record values (%s, %s, %s, 'N')", [Employee_ID, Date, Type])
                    request_accepted = 1

    with connection.cursor() as cursor:
        cursor.execute("select eid, date, type, approved from leave_record where eid = %s and date > '%s-01-01'", [Employee_ID, year])
        rows = cursor.fetchall()
    leaves = []
    for row in rows:
        leaves.append(classes.Leaves(row))
    rows = []
    
    with connection.cursor() as cursor:
        if user_type.head_of_head:
            cursor.execute("select eid, date, type, approved, name from leave_record natural join employee_post natural join (select eid, name from employee) as employee_name where (uid = (select uid from employee_post where eid = %s) or pid = 1) and approved = 'N' and date > '%s-1-1' and eid <> %s", [Employee_ID, year, Employee_ID])
            rows = cursor.fetchall()
        elif user_type.head_of_ULB:
            cursor.execute("select eid, date, type, approved, name from leave_record natural join employee_post natural join (select eid, name from employee) as employee_name where uid = (select uid from employee_post where eid = %s)  and approved = 'N' and date > '%s-1-1' and eid <> %s", [Employee_ID, year, Employee_ID])
            rows = cursor.fetchall()
    employee_leaves = []
    for row in rows:
        employee_leaves.append(classes.Leaves(row))

    with connection.cursor() as cursor:
        if user_type.head_of_ULB:
            cursor.execute("select eid, cid, date, type, approved, name from leave_record natural join contract_based natural join (select cid from contracts where uid = (select uid from employee_post where eid = %s)) as contracts_uid natural join (select eid, name from employee) as employee_name where approved = 'N' and date > '%s-1-1'", [Employee_ID, year])
            rows = cursor.fetchall()
    employee_leaves_contracts = []
    for row in rows:
        employee_leaves_contracts.append(classes.Leaves_Contracts(row))

    return render(request, 'leave.html', {'Name': name, 'UserType': user_type, 'leaves': leaves, 'employee_leaves':employee_leaves, 'employee_leaves_contracts': employee_leaves_contracts, 'request_accepted': request_accepted})


@login_required(login_url="/login")
def payment(request):
    user_type = get_user_type(request)
    if user_type.regularised == False:
        return HttpResponseRedirect('/home/')
    name = get_user_name(request)
    
    if request.GET:
        date = request.GET.get('date')
    else:
        date = str(datetime.datetime.today()).split(' ')[0]
    
    with connection.cursor() as cursor:
        cursor.execute("select eid from employee_login where user = %s", [request.user.id])
        Employee_ID = cursor.fetchone()[0]
        cursor.execute("select date, da_rate, a_hra, b_hra, c_hra, ma, income_tax, interest_rate, provident_fund, gis from rates where date = (select max(date) from rates where date < %s)", [date])
        rates = cursor.fetchone()
        cursor.execute("select ulb_type from employee_post natural join ulb where eid = %s", [Employee_ID])
        city = cursor.fetchone()[0]
        cursor.execute("select account_no, ifsc, date, deductions, basic_pay, grade_pay from employee_account natural join payment natural join salary where eid = %s and date = (select max(date) as date from payment natural join employee_account where date <= %s and eid = %s group by account_no, ifsc)", [Employee_ID, date, Employee_ID])
        row = cursor.fetchone()
    if row is None:
        return render(request, 'payment.html', {'Name': name, 'UserType': user_type, 'payment': None})
    else:
        with connection.cursor() as cursor:
            cursor.execute("select amount, duration from payment_loan natural join (select lid, amount, duration from loan) as loan where account_no = %s and ifsc = %s and date = %s", [row[0], row[1], row[2]])
            loans = cursor.fetchall()
            print(loans)
        transaction = classes.Payments(row, rates, city, loans)

    return render(request, 'payment.html', {'Name': name, 'UserType': user_type, 'payment': transaction})


@login_required(login_url="/login")
def loan(request):
    user_type = get_user_type(request)
    if user_type.regularised == False:
        return HttpResponseRedirect('/home/')
    
    name = get_user_name(request)
    request_accepted = None
    with connection.cursor() as cursor:
        cursor.execute("select eid from employee_login where user = %s", [request.user.id])
        Employee_ID = cursor.fetchone()[0]

    if 'submit' in request.POST:
        with connection.cursor() as cursor:
            if user_type.head_of_head:
                cursor.execute("select eid, lid, amount, date, duration, type, status, paid, name, pid, uid from loan natural join employee_loan natural join employee_post natural join (select eid, name from employee) as employee where status = 'N'")
                rows = cursor.fetchall()
        employee_loans = []
        for row in rows:
            employee_loans.append(classes.Employee_Loans(row))
        
        for i in range(1, len(employee_loans) + 1):
            key = request.POST.get(str(i))
            if key != '0':
                if key[0] == '-':
                    lid = int(key[1:])
                    with connection.cursor() as cursor:
                        cursor.execute("update loan set status = 'C' where lid = %s", [lid])
                else:
                    lid = int(key)
                    with connection.cursor() as cursor:
                        cursor.execute("update loan set status = 'Y' where lid = %s", [lid])

    if 'amount' in request.POST:
        Amount = request.POST.get('amount')
        Duration = request.POST.get('duration')
        Loan_Type = request.POST.get('type')
        Date = str(datetime.datetime.today()).split(' ')[0]
        with transaction.atomic():
            with connection.cursor() as cursor:
                if user_type.head_of_head:
                    cursor.execute("insert into loan(Amount, Date, Duration, Type, Status) values (%s, %s, %s, %s, 'Y')", [Amount, Date, Duration, Loan_Type])
                else:
                    cursor.execute("insert into loan(Amount, Date, Duration, Type, Status) values (%s, %s, %s, %s, 'N')", [Amount, Date, Duration, Loan_Type])
                cursor.execute("select max(lid) from loan")
                LID = cursor.fetchone()[0]
                cursor.execute("insert into employee_loan values (%s, %s)", [Employee_ID, LID])
        request_accepted = 1

    with connection.cursor() as cursor:
        cursor.execute("select lid, amount, date, duration, type, status, paid from loan natural join employee_loan where eid = %s and status <> 'P'", [Employee_ID])
        rows = cursor.fetchall()
    loans = []
    for row in rows:
        loans.append(classes.Loans(row))
    rows = []

    with connection.cursor() as cursor:
        if user_type.head_of_head:
            cursor.execute("select eid, lid, amount, date, duration, type, status, paid, name, pid, uid from loan natural join employee_loan natural join employee_post natural join (select eid, name from employee) as employee where status = 'N'")
            rows = cursor.fetchall()
    employee_loans = []
    for row in rows:
        employee_loans.append(classes.Employee_Loans(row))

    return render(request, 'loan.html', {'Name': name, 'UserType': user_type, 'loans': loans, 'employee_loans':employee_loans, 'request_accepted': request_accepted})


@login_required(login_url="/login")
def orders(request):
    user_type = get_user_type(request)
    name = get_user_name(request)
    year = datetime.datetime.today().year
    request_accepted = False
    
    with connection.cursor() as cursor:
        cursor.execute("select eid from employee_login where user = %s", [request.user.id])
        Employee_ID = cursor.fetchone()[0]
    
    if 'submit_regular' in request.POST:
        with connection.cursor() as cursor:
            if user_type.head_of_head:
                cursor.execute("select eid, name, oid, quantity, item, date, approved from orders natural join orders_placed natural join (select eid, name from employee) as employee_name natural join employee_post where (uid = (select uid from employee_post where eid = %s) or pid = 1) and approved = 'N' and date > '%s-1-1' and eid <> %s", [Employee_ID, year, Employee_ID])
                rows = cursor.fetchall()
            elif user_type.head_of_ULB:
                cursor.execute("select eid, name, oid, quantity, item, date, approved from orders natural join orders_placed natural join (select eid, name from employee) as employee_name natural join employee_post where uid = (select uid from employee_post where eid = %s)  and approved = 'N' and date > '%s-1-1' and eid <> %s", [Employee_ID, year, Employee_ID])
                rows = cursor.fetchall()

        for i in range(1, len(rows) + 1):
            key = request.POST.get(str(i))
            print(key)
            if key != None:
                key = key.split(';')
                date = key[1]
                print(key, date)
                if key[0][0] == '-':
                    oid = int(key[0][1:])
                    with connection.cursor() as cursor:
                        cursor.execute("update orders set approved = 'C' where oid = %s and date = %s", [oid, date])
                else:
                    oid = int(key[0])
                    with connection.cursor() as cursor:
                        cursor.execute("update orders set approved = 'Y' where oid = %s and date = %s", [oid, date])

    if 'submit_contract' in request.POST:
        with connection.cursor() as cursor:
            if user_type.head_of_ULB:
                cursor.execute("select eid, name, oid, quantity, item, cid, date, approved from orders natural join orders_placed natural join contract_based natural join (select cid from contracts where uid = (select uid from employee_post where eid = %s)) as contracts_uid natural join (select eid, name from employee) as employee_name where approved = 'N' and date > '%s-1-1'", [Employee_ID, year])
                rows = cursor.fetchall()
        
        for i in range(1, len(rows) + 1):
            key = request.POST.get(str(-1*i))
            if key != None:
                key = key.split(';')
                date = key[1]
                if key[0][0] == '-':
                    oid = int(key[0][1:])
                    with connection.cursor() as cursor:
                        cursor.execute("update orders set approved = 'C' where oid = %s and date = %s", [oid, date])
                else:
                    oid = int(key[0])
                    with connection.cursor() as cursor:
                        cursor.execute("update orders set approved = 'Y' where oid = %s and date = %s", [oid, date])

    if 'quantity' in request.POST:
        Item = request.POST.get('order')
        Quantity = request.POST.get('quantity')
        Date = str(datetime.datetime.today()).split(' ')[0]
        with transaction.atomic():
            with connection.cursor() as cursor:
                if user_type.head_of_head:
                    cursor.execute("insert into orders(quantity, item, date, approved) values (%s, %s, %s, 'Y')", [Quantity, Item, Date])
                else:
                    cursor.execute("insert into orders(quantity, item, date, approved) values (%s, %s, %s, 'N')", [Quantity, Item, Date])
                cursor.execute("select max(oid) from orders")
                OID = cursor.fetchone()[0]
                cursor.execute("insert into orders_placed values (%s, %s)", [Employee_ID, OID])
        request_accepted = True

    with connection.cursor() as cursor:
        cursor.execute("select eid, oid, quantity, item, date, approved from orders natural join orders_placed where eid = %s and date > '%s-01-01'", [Employee_ID, year])
        rows = cursor.fetchall()
    orders = []
    for row in rows:
        orders.append(classes.Orders(row))
    rows = []
    
    with connection.cursor() as cursor:
        if user_type.head_of_head:
            cursor.execute("select eid, name, oid, quantity, item, date, approved from orders natural join orders_placed natural join (select eid, name from employee) as employee_name natural join employee_post where (uid = (select uid from employee_post where eid = %s) or pid = 1) and approved = 'N' and date > '%s-1-1' and eid <> %s", [Employee_ID, year, Employee_ID])
            rows = cursor.fetchall()
        elif user_type.head_of_ULB:
            cursor.execute("select eid, name, oid, quantity, item, date, approved from orders natural join orders_placed natural join (select eid, name from employee) as employee_name natural join employee_post where uid = (select uid from employee_post where eid = %s)  and approved = 'N' and date > '%s-1-1' and eid <> %s", [Employee_ID, year, Employee_ID])
            rows = cursor.fetchall()
    employee_orders = []
    for row in rows:
        employee_orders.append(classes.Orders_Regular(row))
    
    with connection.cursor() as cursor:
        if user_type.head_of_ULB:
            cursor.execute("select eid, name, oid, quantity, item, cid, date, approved from orders natural join orders_placed natural join contract_based natural join (select cid from contracts where uid = (select uid from employee_post where eid = %s)) as contracts_uid natural join (select eid, name from employee) as employee_name where approved = 'N' and date > '%s-1-1'", [Employee_ID, year])
            rows = cursor.fetchall()
    employee_orders_contracts = []
    for row in rows:
        employee_orders_contracts.append(classes.Orders_Contracts(row))

    return render(request, 'orders.html', {'Name': name, 'UserType': user_type, 'orders': orders, 'employee_orders':employee_orders, 'employee_orders_contracts': employee_orders_contracts, 'request_accepted': request_accepted})



@login_required(login_url="/login")
def transfers(request):
    user_type = get_user_type(request)
    if user_type.regularised == False:
        return HttpResponseRedirect('/home/')
    
    name = get_user_name(request)

    with connection.cursor() as cursor:
        cursor.execute("select eid from employee_login where user = %s", [request.user.id])
        EID = cursor.fetchone()[0]
        cursor.execute("select lower_pid, lower_uid, higher_pid, higher_uid, relieving_date, joining_date from promotion where eid = %s", [EID])
        rows = list(cursor.fetchall())
    transfers = []
    for i in range(len(rows)):
        with connection.cursor() as cursor:
            rows[i] = list(rows[i])
            cursor.execute("select post_name, ulb_name from post natural join ulb where pid = %s and uid = %s", [rows[i][0], rows[i][1]])
            rows[i][0], rows[i][1] = cursor.fetchone()
            cursor.execute("select post_name, ulb_name from post natural join ulb where pid = %s and uid = %s", [rows[i][2], rows[i][3]])
            rows[i][2], rows[i][3] = cursor.fetchone()
        transfers.append(classes.Transfers(rows[i]))

    with connection.cursor() as cursor:
        cursor.execute("select eid from employee_login where user = %s", [request.user.id])
        EID = cursor.fetchone()[0]
        cursor.execute("select iid, lower_pid, lower_uid, higher_pid, higher_uid, relieving_date, joining_date from demotion natural join employee_charges where eid = %s", [EID])
        rows = list(cursor.fetchall())
    demotions = []
    for i in range(len(rows)):
        with connection.cursor() as cursor:
            rows[i] = list(rows[i])
            cursor.execute("select post_name, ulb_name from post natural join ulb where pid = %s and uid = %s", [rows[i][1], rows[i][2]])
            rows[i][1], rows[i][2] = cursor.fetchone()
            cursor.execute("select post_name, ulb_name from post natural join ulb where pid = %s and uid = %s", [rows[i][3], rows[i][4]])
            rows[i][3], rows[i][4] = cursor.fetchone()
        demotions.append(classes.Demotions(rows[i]))

    with connection.cursor() as cursor:
        cursor.execute("select eid from employee natural join employee_post where eid <> %s", [EID])
        rows = cursor.fetchall()
    EIDs = []
    for row in rows:
        EIDs.append(row[0])

    print(request.POST)

    if 'promote_submit' in request.POST:
        promote_eid = int(request.POST.get('promote_EID'))
        Final_ULB = request.POST.get('Final_ULB')
        Final_Post = request.POST.get('Final_Post')
        date = str(datetime.datetime.today()).split(' ')[0]
        joining_date = request.POST.get('Joining_Date')
        with transaction.atomic():
            with connection.cursor() as cursor:
                cursor.execute("select pid, uid from employee_post where eid = %s", [promote_eid])
                Initial_PID, Initial_UID = cursor.fetchone()
                cursor.execute("select pid, uid from post natural join ulb where post_name = %s and ulb_name = %s", [Final_Post, Final_ULB])
                Final_PID, Final_UID = cursor.fetchone()
                cursor.execute("update post set number = number + 1 where pid = %s and uid = %s", [Initial_PID, Initial_UID])
                cursor.execute("update post set number = number - 1 where pid = %s and uid = %s", [Final_PID, Final_UID])
                cursor.execute("update employee_post set pid = %s, uid = %s where eid = %s", [Final_PID, Final_UID, promote_eid])
                cursor.execute("insert into promotion values (%s, %s, %s, %s, %s, %s, %s)", [promote_eid, Initial_PID, Initial_UID, Final_PID, Final_UID, date, joining_date])
                if Final_PID == 7:
                    Employee_GID = 5
                elif Final_PID == 1:
                    if Final_UID == 1:
                        Employee_GID = 4
                    else:
                        Employee_GID = 2
                elif Final_PID == 6:
                    Employee_GID = 6
                else:
                    Employee_GID = 1
                cursor.execute("select user from employee_login where eid = %s", [promote_eid])
                promote_user_id = cursor.fetchone()[0]
                cursor.execute("update auth_user_groups set group_id = %s where user_id = %s", [Employee_GID, promote_user_id])
        
        return render(request, 'transfers.html', {'Name': name, 'UserType': user_type, 'EIDs': EIDs, 'transfer_made': True, 'transfers': transfers, 'demotions': demotions})
    else:
        if 'promote_EID' in request.POST:
            promote_eid = request.POST.get('promote_EID')
            EIDs.remove(int(promote_eid))
            with connection.cursor() as cursor:
                cursor.execute("select name, pid, post_name, uid, ulb_name from employee_post natural join (select eid, name from employee) as employee natural join (select pid, post_name from post) as post natural join (select uid, ulb_name from ulb) as ulb where eid = %s", [promote_eid])
                row = cursor.fetchone()
            Employee_Name = row[0]
            Employee_Init_ULB = row[4]
            Employee_Init_Post = row[2]
            Employee_Init_PID = row[1]
            Employee_Init_UID = row[3]
            with connection.cursor() as cursor:
                cursor.execute("select ulb_name from ulb")
                rows = cursor.fetchall()
            promote_ulbs = []
            for row in rows:
                promote_ulbs.append(row[0])

            if 'Final_ULB' in request.POST:
                promote_uid = request.POST.get('Final_ULB')
                promote_ulbs.remove(promote_uid)
                with connection.cursor() as cursor:
                    if Employee_Init_ULB == promote_uid:
                        cursor.execute("select post_name from post natural join ulb where ulb_name = %s and pid < %s and number > 0", [promote_uid, Employee_Init_PID])
                    else:
                        cursor.execute("select post_name from post natural join ulb where ulb_name = %s and pid <= %s and number > 0", [promote_uid, Employee_Init_PID])
                    rows = cursor.fetchall()
                promote_posts = []
                for row in rows:
                    promote_posts.append(row[0])
                return render(request, 'transfers.html', {'Name': name, 'UserType': user_type, 'transfers': transfers, 'demotions': demotions, 'EIDs': EIDs, 'promote_eid': promote_eid, 'Promote_Name': Employee_Name, 'Promote_ULB': Employee_Init_ULB, 'Promote_Init_Post': Employee_Init_Post, 'promote_ulbs': promote_ulbs, 'promote_uid': promote_uid, 'promote_posts': promote_posts})
            return render(request, 'transfers.html', {'Name': name, 'UserType': user_type, 'transfers': transfers, 'demotions': demotions, 'EIDs': EIDs, 'promote_eid': promote_eid, 'Promote_Name': Employee_Name, 'Promote_ULB': Employee_Init_ULB, 'Promote_Init_Post': Employee_Init_Post, 'promote_ulbs': promote_ulbs})

    if 'demote_submit' in request.POST:
        demote_eid = int(request.POST.get('demote_EID'))
        charge_id = request.POST.get('Charge_ID')
        Final_ULB = request.POST.get('Final_ULB')
        Final_Post = request.POST.get('Final_Post')
        date = str(datetime.datetime.today()).split(' ')[0]
        joining_date = request.POST.get('Joining_Date_Demote')
        with transaction.atomic():
            with connection.cursor() as cursor:
                cursor.execute("select pid, uid from employee_post where eid = %s", [demote_eid])
                Initial_PID, Initial_UID = cursor.fetchone()
                cursor.execute("select pid, uid from post natural join ulb where post_name = %s and ulb_name = %s", [Final_Post, Final_ULB])
                Final_PID, Final_UID = cursor.fetchone()
                cursor.execute("update post set number = number + 1 where pid = %s and uid = %s", [Initial_PID, Initial_UID])
                cursor.execute("update post set number = number - 1 where pid = %s and uid = %s", [Final_PID, Final_UID])
                cursor.execute("update employee_post set pid = %s, uid = %s where eid = %s", [Final_PID, Final_UID, demote_eid])
                cursor.execute("insert into demotion values (%s, %s, %s, %s, %s, %s, %s)", [charge_id, Initial_PID, Initial_UID, Final_PID, Final_UID, date, joining_date])
                if Final_PID == 7:
                    Employee_GID = 5
                elif Final_PID == 1:
                    if Final_UID == 1:
                        Employee_GID = 4
                    else:
                        Employee_GID = 2
                elif Final_PID == 6:
                    Employee_GID = 6
                else:
                    Employee_GID = 1
                cursor.execute("select user from employee_login where eid = %s", [demote_eid])
                demote_user_id = cursor.fetchone()[0]
                cursor.execute("update auth_user_groups set group_id = %s where user_id = %s", [Employee_GID, demote_user_id])

        return render(request, 'transfers.html', {'Name': name, 'UserType': user_type, 'EIDs': EIDs, 'demotion_done': True, 'transfers': transfers, 'demotions': demotions})
    else:
        if 'demote_EID' in request.POST:
            demote_eid = request.POST.get('demote_EID')
            EIDs.remove(int(demote_eid))
            with connection.cursor() as cursor:
                cursor.execute("select name, pid, post_name, uid, ulb_name from employee_post natural join (select eid, name from employee) as employee natural join (select pid, post_name from post) as post natural join (select uid, ulb_name from ulb) as ulb where eid = %s", [demote_eid])
                row = cursor.fetchone()
            Employee_Name = row[0]
            Employee_Init_ULB = row[4]
            Employee_Init_Post = row[2]
            Employee_Init_PID = row[1]
            Employee_Init_UID = row[3]
            with connection.cursor() as cursor:
                cursor.execute("select iid from employee_charges where eid = %s", [demote_eid])
                rows = cursor.fetchall()
            demote_cids = []
            for row in rows:
                demote_cids.append(row[0])
            if len(demote_cids) == 0:
                return render(request, 'transfers.html', {'Name': name, 'UserType': user_type, 'EIDs': EIDs, 'transfers': transfers, 'demotions': demotions, 'demote_eid': demote_eid, 'Demote_Name': Employee_Name, 'Demote_ULB': Employee_Init_ULB, 'Demote_Init_Post': Employee_Init_Post, 'demote_cids': None})
            
            if 'Charge_ID' in request.POST:
                if request.POST.get('Charge_ID') == 'Select Charge ID':
                    return render(request, 'transfers.html', {'Name': name, 'UserType': user_type, 'EIDs': EIDs, 'transfers': transfers, 'demotions': demotions, 'demote_eid': demote_eid, 'Demote_Name': Employee_Name, 'Demote_ULB': Employee_Init_ULB, 'Demote_Init_Post': Employee_Init_Post, 'demote_cids': demote_cids})
                try:
                    charge_id = int(request.POST.get('Charge_ID'))
                except:
                    charge_id = None

                if charge_id in demote_cids:
                    demote_cids.remove(charge_id)
                else:
                    charge_id = None

                with connection.cursor() as cursor:
                    cursor.execute("select charges from charge_sheet where iid = %s", [charge_id])
                    row = cursor.fetchone()
                    if row == None:
                        Charge = row
                    else:
                        Charge = row[0]

                with connection.cursor() as cursor:
                    cursor.execute("select ulb_name from ulb")
                    rows = cursor.fetchall()
                demote_ulbs = []
                for row in rows:
                    demote_ulbs.append(row[0])
            
                if 'Final_ULB' in request.POST:
                    if request.POST.get('Final_ULB') == 'Select New Office':
                        return render(request, 'transfers.html', {'Name': name, 'UserType': user_type, 'transfers': transfers, 'demotions': demotions, 'EIDs': EIDs, 'demote_eid': demote_eid, 'Demote_Name': Employee_Name, 'Demote_ULB': Employee_Init_ULB, 'Demote_Init_Post': Employee_Init_Post, 'demote_ulbs': demote_ulbs, 'demote_cids': demote_cids, 'Charge': Charge, 'charge_id': charge_id})
                    
                    demote_uid = request.POST.get('Final_ULB')
                    try:
                        demote_ulbs.remove(demote_uid)
                    except:
                        pass
                    with connection.cursor() as cursor:
                        cursor.execute("select post_name from post natural join ulb where ulb_name = %s and pid > %s and number > 0", [demote_uid, Employee_Init_PID])
                        rows = cursor.fetchall()
                    demote_posts = []
                    for row in rows:
                        demote_posts.append(row[0])
                    return render(request, 'transfers.html', {'Name': name, 'UserType': user_type, 'transfers': transfers, 'demotions': demotions, 'EIDs': EIDs, 'demote_eid': demote_eid, 'Demote_Name': Employee_Name, 'Demote_ULB': Employee_Init_ULB, 'Demote_Init_Post': Employee_Init_Post, 'demote_ulbs': demote_ulbs, 'demote_uid': demote_uid, 'demote_posts': demote_posts, 'demote_cids': demote_cids, 'Charge': Charge, 'charge_id': charge_id})

                return render(request, 'transfers.html', {'Name': name, 'UserType': user_type, 'transfers': transfers, 'demotions': demotions, 'EIDs': EIDs, 'demote_eid': demote_eid, 'Demote_Name': Employee_Name, 'Demote_ULB': Employee_Init_ULB, 'Demote_Init_Post': Employee_Init_Post, 'demote_ulbs': demote_ulbs, 'demote_cids': demote_cids, 'Charge': Charge, 'charge_id': charge_id})
                    
    
            return render(request, 'transfers.html', {'Name': name, 'UserType': user_type, 'EIDs': EIDs, 'transfers': transfers, 'demotions': demotions, 'demote_eid': demote_eid, 'Demote_Name': Employee_Name, 'Demote_ULB': Employee_Init_ULB, 'Demote_Init_Post': Employee_Init_Post, 'demote_cids': demote_cids})
    
    return render(request, 'transfers.html', {'Name': name, 'UserType': user_type, 'EIDs': EIDs, 'transfers': transfers, 'demotions': demotions})


@login_required(login_url="/login")
def contracts(request):
    user_type = get_user_type(request)
    if user_type.head_of_ULB == False:
        return HttpResponseRedirect('/home/')
    
    name = get_user_name(request)
    date_today = str(datetime.datetime.today()).split(' ')[0]
    request_accepted = None
    with connection.cursor() as cursor:
        cursor.execute("select uid from employee_post where eid = (select eid from employee_login where user = %s)", [request.user.id])
        Employee_UID = cursor.fetchone()[0]

    if 'Contract' in request.POST:
        Contract = request.POST.get('Contract')
        Salary = request.POST.get('Salary')
        Start_Date = request.POST.get('Start_Date')
        End_Date = request.POST.get('End_Date')
        with connection.cursor() as cursor:
            cursor.execute("insert into contracts(contract, salary, date_started, end_date, uid) values (%s, %s, %s, %s, %s)", [Contract, Salary, Start_Date, End_Date, Employee_UID])
        request_accepted = 1

    if 'Name' in request.POST:
        Employee_Name = request.POST.get('Name')
        Employee_CID = request.POST.get('CID')
        Employee_Address = request.POST.get('Address')
        Employee_Age = int(request.POST.get('Age'))
        Employee_Gender = request.POST.get('Gender')
        Employee_Aadhar = request.POST.get('Aadhar')
        Employee_Phone = request.POST.get('Phone')
        Employee_Account = request.POST.get('Account')
        Employee_IFSC = request.POST.get('IFSC')
        with transaction.atomic():
            with connection.cursor() as cursor:
                cursor.execute("select * from employee_account where account_no = %s and ifsc = %s", [Employee_Account, Employee_IFSC])
                if cursor.fetchone() is True:
                    request_accepted = 3
                else:
                    cursor.execute("insert into employee(Name, Address, Age, Gender, Aadhar) values (%s, %s, %s, %s, %s);", [Employee_Name, Employee_Address, Employee_Age, Employee_Gender, Employee_Aadhar])
                    cursor.execute("select max(eid) from employee;")
                    Employee_ID = cursor.fetchall()[0][0]
                    cursor.execute("insert into employee_account values (%s, %s, %s)", [Employee_ID, Employee_Account, Employee_IFSC])
                    cursor.execute("insert into employee_phone values (%s, %s);", [Employee_ID, Employee_Phone])
                    cursor.execute("insert into contract_based values(%s, %s)", [Employee_ID, Employee_CID])
                    user = User.objects.create_user(username=Employee_Name.split(' ')[0] + '-' + str(Employee_ID), password='password_'+str(Employee_ID))
                    #print('password_'+str(Employee_ID))
                    cursor.execute("insert into employee_login values (%s, %s);", [Employee_ID, user.id])
                    Employee_GID = 3
                    cursor.execute("insert into auth_user_groups(user_id, group_id) values (%s, %s)", [user.id, Employee_GID])
                    request_accepted = 2
            
    if 'delete' in request.POST:
        EIDs = request.POST.getlist('delete');
        for EID in EIDs:
            with transaction.atomic():
                with connection.cursor() as cursor:
                    cursor.execute("select user from employee_login where eid = %s", [EID])
                    user_id = cursor.fetchone()[0]
                    cursor.execute("delete from auth_user_groups where user_id = %s", [user_id])
                    cursor.execute("delete from auth_user where id = %s", [user_id])
                    cursor.execute("delete from employee where eid = %s", [EID])

    with connection.cursor() as cursor:
        cursor.execute("select cid, contract, salary, date_started, end_date, uid from contracts where uid = %s and end_date > %s", [Employee_UID, date_today])
        rows = cursor.fetchall()
        assigned_contracts = []
        for row in rows:
            EID = []
            cursor.execute("select eid from contract_based where cid = %s", [row[0]])
            EID.extend(cursor.fetchall())
            assigned_contracts.append(classes.Contracts(row, EID))

    with connection.cursor() as cursor:
        cursor.execute("select eid, name, address, age, gender, aadhar, account_no, ifsc, max_phone from employee natural join contract_based natural join (select cid, uid from contracts) as uid_contract natural join employee_account natural join (select eid, max(phone) as max_phone from employee_phone group by eid) as phone_table where uid = %s", [Employee_UID])
        rows = cursor.fetchall()
    employees = []
    for row in rows:
        employees.append(classes.Employee_Contract(row))

    return render(request, 'contracts.html', {'Name': name, 'UserType': user_type, 'assigned_contracts': assigned_contracts, 'employees': employees, 'request_accepted': request_accepted})


@login_required(login_url="/login")
def employees(request):
    user_type = get_user_type(request)
    if user_type.ULB_admin == False:
        return HttpResponseRedirect('/home/')
    
    name = get_user_name(request)
    request_accepted = 0
    
    with connection.cursor() as cursor:
        cursor.execute("select eid from employee_login where user = %s;", [request.user.id])
        row = cursor.fetchall()
    Admin_EID = row[0][0]

    #print(request.POST)

    if 'delete' in request.POST:
        EIDs = request.POST.getlist('delete');
        for EID in EIDs:
            with transaction.atomic():
                with connection.cursor() as cursor:
                    cursor.execute("update post set number = number + 1 where pid = (select pid from employee_post where eid = %s) and uid = (select uid from employee_post where eid = %s)", [EID, EID])
                    cursor.execute("select user from employee_login where eid = %s", [EID])
                    user_id = cursor.fetchone()[0]
                    cursor.execute("delete from auth_user_groups where user_id = %s", [user_id])
                    cursor.execute("delete from auth_user where id = %s", [user_id])
                    cursor.execute("delete from employee where eid = %s", [EID])


    if 'Name' in request.POST:
        Employee_Name = request.POST.get('Name')
        Employee_Post = request.POST.get('Post')
        Employee_Address = request.POST.get('Address')
        Employee_Age = int(request.POST.get('Age'))
        Employee_Gender = request.POST.get('Gender')
        Employee_Aadhar = request.POST.get('Aadhar')
        Employee_Phone = request.POST.get('Phone')
        Employee_Account = request.POST.get('Account')
        Employee_IFSC = request.POST.get('IFSC')
        with transaction.atomic():
            with connection.cursor() as cursor:
                cursor.execute("select uid from employee_post where eid = %s;", [Admin_EID])
                Employee_UID = cursor.fetchall()[0][0]
                cursor.execute("select pid from post where uid = %s and post_name = %s;", [Employee_UID, Employee_Post])
                Employee_PID = cursor.fetchall()[0][0]
                cursor.execute("select number from post where pid = %s and uid = %s;", [Employee_PID, Employee_UID])
                if cursor.fetchall()[0][0] == 0:
                    request_accepted = 2
                else:
                    cursor.execute("select * from employee_account where account_no = %s and ifsc = %s", [Employee_Account, Employee_IFSC])
                    if cursor.fetchone() is True:
                        request_accepted = 3
                    else:
                        cursor.execute("insert into employee(Name, Address, Age, Gender, Aadhar) values (%s, %s, %s, %s, %s);", [Employee_Name, Employee_Address, Employee_Age, Employee_Gender, Employee_Aadhar])
                        cursor.execute("select max(eid) from employee;")
                        Employee_ID = cursor.fetchall()[0][0]
                        cursor.execute("insert into employee_account values (%s, %s, %s)", [Employee_ID, Employee_Account, Employee_IFSC])
                        cursor.execute("insert into employee_phone values (%s, %s);", [Employee_ID, Employee_Phone])
                        cursor.execute("insert into employee_post values (%s, %s, %s);", [Employee_ID, Employee_PID, Employee_UID])
                        cursor.execute("select sid from initial_pay_scale where pid = %s and uid = %s;", [Employee_PID, Employee_UID])
                        Employee_SID = cursor.fetchall()[0][0]
                        cursor.execute("insert into pay_scale values(%s, %s);", [Employee_ID, Employee_SID])
                        cursor.execute("update post set number = number - 1 where pid = %s and uid = %s;", [Employee_PID, Employee_UID])
                        user = User.objects.create_user(username=Employee_Name.split(' ')[0] + '-' + str(Employee_ID), password='password_'+str(Employee_ID))
                        #print('password_'+str(Employee_ID))
                        cursor.execute("insert into employee_login values (%s, %s);", [Employee_ID, user.id])
                        Date = str(datetime.datetime.today()).split(' ')[0]
                        cursor.execute("insert into regularisation values (%s, %s, %s, %s);", [Employee_ID, Date, Employee_PID, Employee_UID])
                        if Employee_PID == 7:
                            Employee_GID = 5
                        elif Employee_PID == 1:
                            if Employee_UID == 1:
                                Employee_GID = 4
                            else:
                                Employee_GID = 2
                        elif Employee_PID == 6:
                            Employee_GID = 6
                        else:
                            Employee_GID = 1
                        cursor.execute("insert into auth_user_groups(user_id, group_id) values (%s, %s)", [user.id, Employee_GID])
                        request_accepted = 1

    with connection.cursor() as cursor:
        cursor.execute("select eid, name, pid, post_name, age, gender, max_phone from (select * from employee natural join employee_post natural join post where uid = (select uid from employee_post where eid = %s)) as employee_data natural join (select eid, max(phone) as max_phone from employee_phone group by eid) as phone_table order by eid", [Admin_EID])
        rows = cursor.fetchall()
    employees = []
    for row in rows:
        employees.append(classes.Employee_Posts(row))

    return render(request, 'employees.html', {'Name': name, 'UserType': user_type, 'employees': employees, 'request_accepted': request_accepted})


@login_required(login_url="/login")
def update_employee(request):
    user_type = get_user_type(request)
    if user_type.ULB_admin == False:
        return HttpResponseRedirect('/home/')
    
    name = get_user_name(request)
    eid = None
    request_accepted = 0
    with connection.cursor() as cursor:
        cursor.execute("select eid from employee_login where user = %s;", [request.user.id])
        row = cursor.fetchall()
    Admin_EID = row[0][0]
    print(request.POST)

    if 'EID' in request.POST:
        eid = request.POST.get('EID')
        
    if 'dependent' in request.POST:
        Dependent_Name = request.POST.get('Dependent_Name')
        Dependent_Address = request.POST.get('Dependent_Address')
        Dependent_Age = request.POST.get('Dependent_Age')
        Dependent_Gender = request.POST.get('Dependent_Gender')
        Dependent_Aadhar = request.POST.get('Dependent_Aadhar')
        Dependent_Relation = request.POST.get('Dependent_Relation')
        Dependent_EID = request.POST.get('eid_dependents')
        with connection.cursor() as cursor:
            cursor.execute("insert into dependents values (%s, %s, %s, %s, %s, %s, %s)", [Dependent_Aadhar, Dependent_EID, Dependent_Name, Dependent_Address, Dependent_Age, Dependent_Gender, Dependent_Relation])
        request_accepted = 1
        eid = None

    if 'charges' in request.POST:
        Charges = request.POST.get('Charges')
        Decision = request.POST.get('Decision')
        Appeal = request.POST.get('Appeal')
        EID = request.POST.get('eid_charges')
        with transaction.atomic():
            with connection.cursor() as cursor:
                cursor.execute("insert into charge_sheet(decision, appeal, charges) values (%s, %s, %s)", [Decision, Appeal, Charges])
                cursor.execute("select max(iid) from charge_sheet")
                IID = cursor.fetchone()[0]
                cursor.execute("insert into employee_charges values (%s, %s)", [EID, IID])
        request_accepted = 1
        eid = None

    with connection.cursor() as cursor:
        cursor.execute("select uid from employee_post where eid = %s", [Admin_EID])
        Admin_UID = cursor.fetchone()[0]
        cursor.execute("select eid from employee natural join employee_post where uid = %s", [Admin_UID])
        rows = cursor.fetchall()
    EIDs = []
    for row in rows:
        EIDs.append(row[0])

    return render(request, 'update_employee.html', {'Name': name, 'UserType': user_type, 'EIDs':EIDs, 'eid': eid, 'request_accepted': request_accepted})


@login_required(login_url="/login")
def make_payment(request):
    user_type = get_user_type(request)
    if user_type.ULB_Accountant == False:
        return HttpResponseRedirect('/home/')

    name = get_user_name(request)
    date = str(datetime.datetime.today()).split(' ')[0]
    requests_rejected = []
    
    with connection.cursor() as cursor:
        cursor.execute("select eid from employee_login where user = %s", [request.user.id])
        Employee_ID = cursor.fetchone()[0]
        cursor.execute("select date, da_rate, a_hra, b_hra, c_hra, ma, income_tax, interest_rate, provident_fund, gis from rates where date = (select max(date) from rates where date < %s)", [date])
        rates = cursor.fetchone()
        cursor.execute("select ulb_type from employee_post natural join ulb where eid = %s", [Employee_ID])
        city = cursor.fetchone()[0]
        cursor.execute("select eid, name, account_no, ifsc, sid, basic_pay, grade_pay from employee_account natural join (select eid, name from employee) as employee natural join pay_scale natural join salary where eid = ANY(select eid from employee_post where uid = (select uid from employee_post where eid = %s))", [Employee_ID])
        rows = cursor.fetchall()
    payments = []
    for row in rows:
        with connection.cursor() as cursor:
            cursor.execute("select lid, amount, duration from employee_loan natural join loan where eid = %s and status = 'Y'", [row[0]])
            loans = cursor.fetchall()
        payments.append(classes.Make_Payment(row, rates, city, loans))

    with connection.cursor() as cursor:
        cursor.execute("select income_tax from rates where date = (select max(date) from rates where date < %s)", [str(datetime.datetime.today()).split(' ')[0]])
        rates = cursor.fetchone()[0]
        cursor.execute("select cid, eid, name, account_no, ifsc, salary from employee_account natural join (select eid, name from employee) as employee natural join contract_based natural join (select cid, salary from contracts) as contract_salary where eid = ANY(select eid from contract_based natural join contracts where uid = (select uid from employee_post where eid = %s) and end_date > %s)", [Employee_ID, date])
        rows = cursor.fetchall()
    contract_payments = []
    for row in rows:
        contract_payments.append(classes.Contract_Make_Payment(row, rates))

    if 'submit_regular' in request.POST:
        for eid in request.POST.getlist('pay'):
            eid = int(eid)
            deduction = int(request.POST.get(str(eid)))
            for payment in payments:
                if payment.EID == eid:
                    with transaction.atomic():
                        with connection.cursor() as cursor:
                            cursor.execute("select * from payment where account_no = %s and ifsc = %s and date = %s", [payment.Account_No, payment.IFSC, date])
                            if len(cursor.fetchall()) > 0:
                                requests_rejected.append(payment.EID)
                            else:
                                cursor.execute("insert into payment values (%s, %s, %s, %s, %s)", [payment.Account_No, payment.IFSC, payment.SID, date, deduction])
                                for i in range(len(payment.LIDs)):
                                    cursor.execute("insert into payment_loan values(%s, %s, %s, %s)", [payment.Account_No, payment.IFSC, date, int(payment.LIDs[i])])
                                    cursor.execute("update loan set paid = %s, months = months + 1 where lid = %s", [int(payment.Loans[i]), payment.LIDs[i]])
                                    cursor.execute("select months, duration from loan where lid = %s", [payment.LIDs[i]])
                                    row = cursor.fetchone()
                                    month = row[0]
                                    duration = row[1]
                                    if month == duration*12:
                                        cursor.execute("update loan set status = 'P' where lid = %s", [payment.LIDs[i]])

    if 'submit_contract' in request.POST:
        for eid in request.POST.getlist('pay'):
            eid = int(eid)
            deduction = int(request.POST.get(str(eid)))
            for payment in contract_payments:
                if payment.EID == eid:
                    with transaction.atomic():
                        with connection.cursor() as cursor:
                            cursor.execute("select * from contract_payment where account_no = %s and ifsc = %s and date = %s and cid = %s", [payment.Account_No, payment.IFSC, date, payment.CID])
                            if len(cursor.fetchall()) > 0:
                                requests_rejected.append(payment.EID)
                            else:
                                cursor.execute("insert into contract_payment values (%s, %s, %s, %s, %s)", [payment.Account_No, payment.IFSC, date, payment.CID, deduction])

    return render(request, 'make_payment.html', {'Name': name, 'UserType': user_type, 'payments': payments, 'contract_payments': contract_payments, 'requests_rejected': requests_rejected})


@login_required(login_url="/login")
def deauth(request):
    logout(request)
    return render(request, 'login.html')
