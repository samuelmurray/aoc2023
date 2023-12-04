if [ -z $1 ]; then
    echo Provide the day!
    exit 1
fi

if [ -d "Sources/Day(eval $1)" ]; then
    echo "Sources/Day(eval $1) already exists!"
    exit 1
fi

mkdir Sources/Day${1}
touch Sources/Day${1}/code.swift
mkdir Tests/Day${1}Tests
touch Sources/Day${1}Tests/test.swift
mkdir Tests/Day${1}Tests/Resources