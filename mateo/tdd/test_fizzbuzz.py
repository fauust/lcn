import pytest
from fizzbuzz import fizzbuzz

def test_returns_number_for_normal_number():
    assert fizzbuzz(1) == "1"
    assert fizzbuzz(2) == "2"
    assert fizzbuzz(4) == "4"

def test_returns_fizz_for_multiples_of_3():
    assert fizzbuzz(3) == "Fizz"
    assert fizzbuzz(6) == "Fizz"
    assert fizzbuzz(9) == "Fizz"

def test_returns_buzz_for_multiples_of_5():
    assert fizzbuzz(5) == "Buzz"
    assert fizzbuzz(10) == "Buzz"
    assert fizzbuzz(20) == "Buzz"

def test_returns_fizzbuzz_for_multiples_of_both_3_and_5():
    assert fizzbuzz(15) == "FizzBuzz"
    assert fizzbuzz(30) == "FizzBuzz"
    assert fizzbuzz(45) == "FizzBuzz"

def test_generate_sequence():
    from fizzbuzz import generate_sequence
    expected = ["1", "2", "Fizz", "4", "Buzz", "Fizz", "7", "8", "Fizz", "Buzz"]
    assert generate_sequence(10) == expected
