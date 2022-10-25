num_test_cases=5
test_case_value=$((50/$num_test_cases))

for file in Submissions/*.txt
do	
	points=0
	name=1
	no_globals=1
	test_cases_failed=0
	compiles=1
	recursive=1
	flag=0
	
	if [[ $file != *"pa2"* ]]
	then
		name=0
	fi

	grep -Fwq -m 1 ".space" $file
	if [ $? -eq 0 ]
	then
		no_globals=0
		flag=1
	fi
	
	cp ${file} pa2.s
	gcc -o pa2 pa2.s >/dev/null
	
	if [ $? -ne 0 ]
	then
		test_cases_failed=num_test_cases
		compiles=0
		recursive=0
	fi
	
	if [[ compiles -eq 1 ]]; then
	
		for i in {1..5}
		do
			
			timeout 3s stdbuf -oL ./pa2 <Input/pa2/$i.in >Output/pa2/test-$i.out
			exit_status=$?
			
			# check timeout
			if [[ $exit_status -eq 124 ]]; then
				let "test_cases_failed++"
			fi
			
			# check segfault
			if [[ $exit_status -eq 139 ]]; then
				let "test_cases_failed++"
				continue
			fi
			
			diff Output/pa2/test-$i.out Output/pa2/$i.out >/dev/null
			
			# check bad output
			if [ $? -ne 0 ]; then
				let "test_cases_failed++"
			fi
			
			rm Output/pa2/test-$i.out
		done
		
		# test for recursion *if it doesn't seg fault, it needs to be flagged for review*
		timeout 3s stdbuf -oL ./pa2 <Input/pa2/segfault.in >/dev/null
		exit_status=$?
		if [[ $exit_status -ne 139 ]]
		then
			let "recursive--"
			flag=1
		fi
	
	fi
	
	points=$((points + ($name*10)))
	points=$((points + ($compiles*10)))
	points=$((points + ($num_test_cases-$test_cases_failed)*$test_case_value))
	points=$((points + ($recursive * 15)))
	points=$((points + (no_globals*15)))
	
	echo "${file} ${points} ${flag}"
	rm pa2.s
	rm pa2
	
done
