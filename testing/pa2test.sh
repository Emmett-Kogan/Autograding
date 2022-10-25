num_test_cases=5 # 5 public cases and recursion test case
test_case_value=$((50/$num_test_cases))

for file in Submissions/*.txt
do
	name=1
	no_globals=1 # if 1, then no globals (so points calc is easy), if 0 then globals found (?)
	test_cases_failed=0
	compiles=1
	recursive=1
	
	if [[ $file != *"pa2"* ]]
	then
		name=0
	fi
	
	# remember, if grep finds the word, it returns 0
	# .space is how they shouldn't be getting input/storing variables
	# since it involves using global variables/.data section
	grep -Fwq -m 1 ".space" $file
	if [ $? -eq 0 ]
	then
		echo "Possible global variables used"
		no_globals=0
	fi
	
	echo "${file}"
	cp ${file} pa2.s
	gcc -o pa2 pa2.s
	
	if [ $? -ne 0 ]
	then
		echo "Program failed to compile"
		test_cases_failed=num_test_cases
		compiles=0
		recursive=0
	fi
	
	if [[ compiles -eq 1 ]]; then
	
		for i in {1..5}
		do
			
			timeout 3s stdbuf -oL ./pa2 <Input/pa2/$i.in >Output/pa2/test-$i.out
			exit_status=$?
			
			if [[ $exit_status -eq 124 ]]; then
				echo "Program timed out with ${i}.in -- test case failed"
				let "test_cases_failed++"
			fi
			
			if [[ $exit_status -eq 139 ]]; then
				echo "Segfault with ${i}.in"
				let "test_cases_failed++"
				continue
			fi
			
			diff Output/pa2/test-$i.out Output/pa2/$i.out
			
			if [ $? -ne 0 ]; then
				echo "Test case $i failed"
				let "test_cases_failed++"
			fi
			
			rm Output/pa2/test-$i.out
		done
		
		timeout 3s stdbuf -oL ./pa2 <Input/pa2/segfault.in >/dev/null
		exit_status=$?
		if [[ $exit_status -ne 139 ]]
		then
			echo "Program likely wasn't written with recursion (check code)"
			let "recursive--"
		fi
	
	fi
	
	echo "Test cases failed: $test_cases_failed"
	points=$((name*10))
	echo "Named pa2.txt: $points/10"
	points=$(($compiles*10))
	echo "Compiles points: $points/10"
	points=$((($num_test_cases-$test_cases_failed)*$test_case_value))
	echo "Test case points: $points/50"
	points=$(($recursive * 15))
	echo "Recursive points (possible false positives/negatives): $points/15"
	points=$((no_globals*15))
	echo "No global variable points (still need to ensure that arguement registers are used): $points/15"
	echo
	
	rm pa2.s
	rm pa2
	
done
