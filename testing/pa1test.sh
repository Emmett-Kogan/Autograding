for file in Submissions/*.txt
do

echo "${file}"
cp ${file} pa1.s
gcc -o pa1 pa1.s

if [ $? -ne 0 ]
then
	echo "Program failed to compile"
	continue
fi

for i in {1..10}
do

timeout 3s stdbuf -oL ./pa1 <Input/pa1/$i.in >Output/pa1/test-$i.out
exit_status=$?

if [[ $exit_status -eq 124 ]]; then
	echo "Program timed out with ${i}.in"
fi

diff Output/pa1/test-$i.out Output/pa1/$i.out
rm Output/pa1/test-$i.out
done

rm pa1.s
rm pa1

done
