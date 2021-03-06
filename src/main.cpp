/*
Use, modification, and distribution are
subject to the Boost Software License, Version 1.0. (See accompanying
file LICENSE.txt)

Copyright René Ferdinand Rivera Morell 2020-2021.
*/

#include <vector>
#include <iostream>

int main()
{
	std::vector<char> numbers;
	for (int n = 0; n < 100; ++n) numbers.push_back(n);
	int sum = 0;
	for (int m = 0; m < numbers.size(); ++m) sum += numbers[m];
	std::cout << "CI Playground... " << sum << "\n" ;
	return 0;
}
