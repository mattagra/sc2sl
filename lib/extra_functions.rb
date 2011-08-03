def truncate_words(text, length = 200, end_string = '(…)', chars = 0)
  if chars != 0 
    text = text[0,chars]
  end
  words = text.split()
  words[0..(length-1)].join(' ') + (words.length > length ? end_string : '')
end