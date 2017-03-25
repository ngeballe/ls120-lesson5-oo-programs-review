def joinor(array, delimiter=', ', conjunction='or')
  return array[0] if array.size == 1
  return array.join(" #{conjunction} ") if array.size == 2
  array_copy = array.dup
  array_copy[-1] = "#{conjunction} #{array[-1]}"
  array_copy.join(delimiter)
end

p joinor([1, 2])                   # => "1 or 2"
p joinor([1, 2, 3])                # => "1, 2, or 3"
p joinor([1, 2, 3], '; ')          # => "1; 2; or 3"
p joinor([1, 2, 3], ', ', 'and')   # => "1, 2, and 3"
