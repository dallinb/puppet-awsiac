$az_list = ['a', 'b', 'c']
$number = 4
$letter = $az_list[ $number % count($az_list) - 1 ]

notify { $letter: }
