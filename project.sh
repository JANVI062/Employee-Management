#!/bin/sh
emp="employee.txt"

#Inserting Employee Details to the file
addRecord()
{
	echo "============================="
	echo " ENTER EMPLOYEE INFORMATION"
	echo "============================="
	total=0
	while [ $total -eq 0 ]
	do
		echo -n "Enter employee ID: "
		read no
		#Checking whether the input ID already exists in the file or not
		total=`cat $emp | cut -d '|' -f1 |grep -cwi $no`
        	if [ $total -gt 0 ]
        	then
			echo "This ID already exists!!"
			total=0
		else
			echo -n "Enter employee name: "
			read name
			echo -n "Enter employee age: "
			read age
			echo -n "Enter employee gender: "
			read gen
			echo -n "Enter employee job: "
			read job
			echo -n "Enter employee annual basic salary: "
			read sal
       			echo -n "Enter date of joining (yyyy/mm/dd): "
			read date
			record="$no|$name|$age|$gen|$job|$sal|$date"
			echo $record >> $emp
			echo "EMPLOYEE INFORMATION ADDED SUCCESSFULLY."
			total=1
		fi
	done
}

#Updating Employee details
update()
{
	echo "=============================="
	echo " MODIFY EMPLOYEE INFORMATION"
	echo "=============================="

	#Taking employee ID as input from user
	echo -n "Enter employee ID :"
	read no
	
	total=`cat $emp | cut -d '|' -f1 | grep -cwi $no`
	if [ $total -gt 0 ]
	then
		record=`cat $emp | cut -d '|' -f1 | grep -wi $no`
		echo "=========================================="
		echo " ENTER EMPLOYEE INFORMATION FOR ID : $no"
		echo "=========================================="
		echo -n "Enter employee name: "
		read name
		echo -n "Enter employee age: "
		read age
		echo -n "Enter employee gender: "
		read gen
		echo -n "Enter employee job: "
		read job
		echo -n "Enter employee salary: "
		read sal
        	echo -n "Enter date of joining (yyyy/mm/dd): "
		read date
		updatedrecord="$no|$name|$age|$gen|$job|$sal|$date"
		totalrecords=`cat $emp | wc -l`
		i=1
		while [ $i -le $totalrecords ]
		do
			record=`cat $emp | head -$i | tail -1`
			findrecord=`echo $record | cut -d '|' -f1  | grep -wci $no`
			if [ $findrecord -eq 0 ]
			then
				echo "$record" >> "tempdata"
			else
				echo "$updatedrecord" >> "tempdata"
			fi
			i=`expr $i + 1`
		done

		#Move updated data to emp file
		mv "tempdata" "$emp"
		echo "RECORD UPDATED SUCCESSFULLY."
	else
		echo "NO RECORD FOUND!!"
	fi
}

#Salary Operations
cal_salary()
{
	#Calculating Total Salary till date
	salary()
    	{
		echo -n "Enter employee id: "
   		read id
                total=`cat $emp | cut -d "|" -f1 | grep -cwi $id`
                if [ $total -gt 0 ]
                then
                	for j in `cat $emp`
                    	do
        	            	emp_no=$(echo $j | cut -d "|" -f1 )
                	    	name=$(echo $j | cut -d "|" -f2 )
                    		basic=$(echo $j | cut -d "|" -f6 )
                   		join_date=$(echo $j | cut -d "|" -f7 )
                   		if [[ $id -eq $emp_no ]]
                    		then
					#Difference between joining date and current date
                    			date1=`date -d "$join_date" "+%s"`
                    			date2=`date "+%s"`
                    			diff=$(($date2-$date1))
                    			days=$(($diff/(60*60*24)))
		    			sal_per_day=$(($basic/365))

					#Calculating Total salary according to days
		    			total_sal=$(($days * $sal_per_day))
                    			echo "Name: "$name
					echo "Total Salary: "$total_sal
        			fi
        		done
                else
		        echo "NO RECORD FOUND!!"
		fi
    	}

	#Calculating Gross salary for a particular Employee
	gross_salary()
	{
		#Gross Salary = Basic salary + HRA + DA.
       		#HRA=10% and DA= 15%.
        
		echo -n "Enter employee ID: "
                read id
                total=`cat $emp |cut -d "|" -f1 | grep -cwi $id`
                if [ $total -gt 0 ]
                then
			for j in `cat $emp`
                    	do
            			emp_no=$(echo $j | cut -d "|" -f1 )
				name=$(echo $j | cut -d "|" -f2 )
				basic=$(echo $j | cut -d "|" -f6 )
            			if [[ $id -eq $emp_no ]]
            			then
					echo "Name: "$name
					echo "Basic salary: "$basic

					hra=`expr $basic \* 10`
					hra=`expr $hra / 100`
					da=`expr $basic \* 15`
					da=`expr $da / 100`
		
					gross=`expr $basic + $hra + $da`
					echo "Gross Salary: "$gross
        			fi
            		done
		else
			echo "NO RECORD FOUND!!"
		fi
	}
	
	#Employee with Max Salary
	max_sal()
	{
		#Selecting salary column from the file
		for i in `cat $emp`
        	do
			salary[$i]=$(echo $i | cut -d "|" -f6 )
        	done

		max=${salary[0]}
	       	for i in ${salary[@]}
	      	do
			if [[ $i -gt $max ]]
                	then
			      	max=$i
            		fi
		done
	       	echo "Maximum salary is: " $max
	        echo
	        echo "The details of Employee(s) having Maximum Salary: "
	        for record in `cat $emp | grep -wi $max`
	    	do
		        emp_no=`echo $record | cut -d "|" -f1`
			emp_name=`echo $record | cut -d "|" -f2`
            		emp_age=`echo $record | cut -d "|" -f3`
            		emp_gen=`echo $record | cut -d "|" -f4`
            		emp_job=`echo $record | cut -d "|" -f5`
            		emp_sal=`echo $record | cut -d "|" -f6`
        	        emp_date=`echo $record | cut -d "|" -f7`
            		echo "===================================="
            		echo "Employee ID: " $emp_no
            		echo "Employee Name: " $emp_name
            		echo "Employee Age: " $emp_age
            		echo "Employee Gender: " $emp_gen
            		echo "Employee Job: " $emp_job
            		echo "Employee salary: " $emp_sal
                    	echo "Date of Joining: " $emp_date
            		echo "===================================="
            		echo 
       		 done
	}
   	
	#Employee with min Salary
 	min_sal()
        {
		#Selecting salary column from the file
                for i in `cat $emp`
                do
			sal[$i]=$(echo $i | cut -d "|" -f6)
                done

		min=999999999
                for i in ${sal[@]}
                do
                        if [[ $i -lt $min ]]
                        then
			      	min=$i
                        fi
                done
		
                echo "Minimum salary is : " $min
                echo 
                echo "The details of Employee(s) having Minimum Salary : "
                for record in `cat $emp | grep -wi $min`
                do
                        emp_no=`echo $record | cut -d "|" -f1`
                        emp_name=`echo $record | cut -d "|" -f2`
                        emp_age=`echo $record | cut -d "|" -f3`
                        emp_gen=`echo $record | cut -d "|" -f4`
                        emp_job=`echo $record | cut -d "|" -f5`
                        emp_sal=`echo $record | cut -d "|" -f6`
                        emp_date=`echo $record | cut -d "|" -f7`
                        echo "===================================="
                        echo "Employee ID: " $emp_no
                        echo "Employee Name: " $emp_name
                        echo "Employee Age: " $emp_age
                        echo "Employee Gender: " $emp_gen
                        echo "Employee Job: " $emp_job
                        echo "Employee salary: " $emp_sal
                        echo "Date of Joining: " $emp_date
                        echo "===================================="
		done
	}

	#SUB-MENU for Salary Operations
	ch=0
	while [ $ch -ne 5 ]
	do
		echo "
	    	-------------------------------------------------------
	     	1. Calculate Total salary
		2. Calculate gross salary of Employee
		3. Employee with maximum salary
	        4. Employee with minimum salary
	  	5. EXIT to the Main Menu
		-------------------------------------------------------"
	        echo
	        echo -n "Enter your choice :"
	        read ch
	        case $ch in
			1) salary;;
		      	2) gross_salary;;
		     	3) max_sal;;
	                4) min_sal;;
	                5) return;;
	                *) echo "Invalid choice!";;
	       	esac
	done
}

#Counting Total records of the file
getTotalRecords()
{
    total=`wc -l < $emp`
    echo "Total records: "$total
}

#Display Employees
display()
{
	#Display all employee details
	display_all()
	{
		total=`wc -l < $emp`
		if  [ $total -gt 0 ]
		then
			j=1
			for i in `cat $emp`
			do
				echo "===================================="
				echo "Employee - "$j
				echo "============="
				emp_no=`echo $i | cut -d "|" -f1`
				emp_name=`echo $i | cut -d "|" -f2`
				emp_age=`echo $i | cut -d "|" -f3`
				emp_gen=`echo $i| cut -d "|" -f4`
				emp_job=`echo $i | cut -d "|" -f5`
				emp_sal=`echo $i | cut -d "|" -f6`
                		emp_date=`echo $i | cut -d "|" -f7`
                
				echo "Employee ID: " $emp_no
				echo "Employee Name: " $emp_name
				echo "Employee Age: " $emp_age
				echo "Employee Gender: " $emp_gen
				echo "Employee Job: " $emp_job
				echo "Employee salary: " $emp_sal
                		echo "Date of Joining: " $emp_date
				j=`expr $j + 1`
				echo "===================================="
				echo
			done
		else
			echo "NO RECORD FOUND!!"
		fi
	}
    
	#Display employee details for a particular ID
	display_id()
        {
		#Input ID from the user
                echo -n "Enter employee ID: "
                read id
		total=0
                total=`cat $emp | cut -d "|" -f1 | grep -cw $id`
                if [ $total -gt 0 ]
                then
                	for j in `cat $emp`
                    	do
                        	emp_no=`echo $j | cut -d "|" -f1`
                        	emp_name=`echo $j| cut -d "|" -f2`
                        	emp_age=`echo $j | cut -d "|" -f3`
                        	emp_gen=`echo $j | cut -d "|" -f4`
                        	emp_job=`echo $j | cut -d "|" -f5`
                        	emp_sal=`echo $j | cut -d "|" -f6`
                        	emp_date=`echo $j | cut -d "|" -f7`
                        	if [ $id -eq $emp_no ]
                        	then
                        		echo "================================"
                        		echo "Employee ID: " $emp_no
                       			echo "Employee Name: " $emp_name
                        		echo "Employee Age: " $emp_age
                        		echo "Employee Gender: " $emp_gen
                        		echo "Employee Job: " $emp_job
                        		echo "Employee salary: " $emp_sal
                        		echo "Date of Joining :" $emp_date
                        		echo "================================"
                        	fi
                        done
		else
                	echo "NO RECORD FOUND!!"
                        fi
	}

	#Display Employee details according to the name entered
	display_name()
	{
		echo -n "Enter employee name :"
		read name
		total=`cat $emp | grep -cwi $name`
		if [ $total -gt 0 ]
		then
			j=1
                        for i in `cat $emp | grep -wi $name`
                        do
                                echo "===================================="
                                echo "Employee - "$j
                                echo "============="
                                emp_no=`echo $i | cut -d "|" -f1`
                                emp_name=`echo $i | cut -d "|" -f2`
                                emp_age=`echo $i | cut -d "|" -f3`
                                emp_gen=`echo $i| cut -d "|" -f4`
                                emp_job=`echo $i | cut -d "|" -f5`
                                emp_sal=`echo $i | cut -d "|" -f6`
                                emp_date=`echo $i | cut -d "|" -f7`
                                echo "Employee ID: " $emp_no
                                echo "Employee Name: " $emp_name
                                echo "Employee Age: " $emp_age
                                echo "Employee Gender: " $emp_gen
                                echo "Employee Job: " $emp_job
                                echo "Employee salary: " $emp_sal
                                echo "Date of Joining :" $emp_date
                                j=`expr $j + 1`
                                echo "===================================="
                                echo
                        done
		else
			echo "NO RECORD FOUND!!"
		fi
	}
	
	#Display employee details according to the job entered 
        display_job()
        {
		echo -n "Enter the job :"
                read job
                total=`cat $emp | grep -cwi $job`
                if  [ $total -gt 0 ]
                then
                        j=1
                        for i in `cat $emp | grep -wi $job`
                        do
                                echo "===================================="
                                echo "Employee - "$j
                                echo "============="
                                emp_no=`echo $i | cut -d "|" -f1`
                                emp_name=`echo $i | cut -d "|" -f2`
                                emp_age=`echo $i | cut -d "|" -f3`
                                emp_gen=`echo $i| cut -d "|" -f4`
                                emp_job=`echo $i | cut -d "|" -f5`
                                emp_sal=`echo $i | cut -d "|" -f6`
                                emp_date=`echo $i | cut -d "|" -f7`
                                echo "Employee ID: " $emp_no
                                echo "Employee Name: " $emp_name
                                echo "Employee Age: " $emp_age
                                echo "Employee Gender: " $emp_gen
                                echo "Employee Job: " $emp_job
                                echo "Employee salary: " $emp_sal
                                echo "Date of Joining :" $emp_date
                                j=`expr $j + 1`
                                echo "===================================="
                                echo
                        done
                else
                        echo "NO RECORD FOUND!!"
	     	fi
	}

	#SUB-MENU for display operation
	ch=0	
	while [ $ch -ne 5 ]
	do
		echo "
		-------------------------------------------------------
        	1. Display details of all employees
		2. Display employee details by ID 
		3. Display employee(s) details by name
		4. Display employee(s) details of a particular job
        	5. EXIT to the Main Menu
		-------------------------------------------------------"
	echo
        echo -n "Enter your choice: "
        read ch
	case $ch in
		1) display_all;;
		2) display_id;;
		3) display_name;;
		4) display_job;;
		5) return;;
		*) echo "Invalid choice!";;
	esac
	done
}

#Delete Employee Record from the file
deleteEmployee()
{
	echo "=============================="
	echo " DELETE EMPLOYEE INFORMATION"
	echo "=============================="
	echo -n "Enter employee ID: "
	read no
	total=`cat $emp | cut -d "|" -f1 | grep -cwi $no`
	if [ $total -gt 0 ]
	then
		totalrecords=`cat $emp | wc -l`
		i=1
		while [ $i -le $totalrecords ]
		do
			record=`cat $emp | head -$i | tail -1`
			findrecord=`echo $record |cut -d "|" -f1 | grep -wci $no`
			if [ $findrecord -eq 0 ]
			then
				echo "$record" >> "tempdata"
			fi
			i=`expr $i + 1`
		done

		#Move updated data in emp file
		mv "tempdata" "$emp"
		echo "DELETED SUCCESSFULLY."

	elif [ $total -eq 0 ]
	then
		echo "NO RECORD FOUND!!"
	fi
}

#Project Description
echo
echo " 			EMPLOYEE MANAGEMENT SYSTEM		"
echo "
	The project deals with  management for the employees of any 
      	organisation. It has features like adding, updating and deleting 
      	employee details,viewing total number of records, calculating 
	total, gross salary and displaying the records can be done by 
	various methods like according to id, name, job, employees wih 
	max or min salary."
echo

#Main-Menu
choice=0
while [ $choice -ne 7 ]
do
	echo "
	**************************MAIN MENU****************************
	1. ADD Employee
	2. UPDATE Employee
	3. PERFORM Salary Operations
	-(Total Salary,Gross Salary, Max Salary and Min Salary)
	4. COUNT Total no. of Employees
	5. DISPLAY Employees
	6. DELETE Employee
	7. EXIT
	***************************************************************"
	echo 
	echo -n "Enter your choice : "
	read choice
	case $choice in
		1) addRecord;;
		2) update;;
        	3) cal_salary;;
		4) getTotalRecords;;
        	5) display;;
		6) deleteEmployee;;
        	7) exit;;
        	*) echo "Invalid choice!";;
	esac
done

