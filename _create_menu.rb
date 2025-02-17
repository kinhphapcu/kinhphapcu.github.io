# Get the filenames of all chapters
yml_file_content = File.read("_quarto.yml")

chapter_filename_regex = /- ([a-z0-9-]+).qmd/

chapter_filenames_scan_result = yml_file_content.scan chapter_filename_regex

chapter_filenames = []
chapter_filenames_scan_result.each {|scan_result| chapter_filenames << scan_result[0]}

# remove the `index` from array of filenames
chapter_filenames.shift

chapter_links = ""

chapter_filenames.each do |file_name|
	file_content = File.read("#{file_name}.qmd")
	title_regex = /^# (.*) {- ##{file_name}}/
	chapter_title_scan_result = file_content.scan title_regex
	chapter_title = chapter_title_scan_result[0][0]

	verse_number_regex = /#ke-so-(\d+)/
	verse_number_scan_result = file_content.scan verse_number_regex
	verse_numbers = []
	verse_number_scan_result.each do |result|
		verse_numbers << result[0]
	end

	case verse_numbers.length
	# when 1
	# 	link_text = "#{chapter_title} (Kệ số #{verse_numbers[0]})"
	# when 2
	# 	link_text = "#{chapter_title} (Kệ số #{verse_numbers[0]}, #{verse_numbers[1]})"
	# else
	# 	link_text = "#{chapter_title} (Kệ số #{verse_numbers[0]} - #{verse_numbers[-1]})"
	# end

	when 1
		link_text = "Kệ số #{verse_numbers[0]}: #{chapter_title}"
	when 2
		link_text = "Kệ số #{verse_numbers[0]}, #{verse_numbers[1]}: #{chapter_title}"
	else
		link_text = "Kệ số #{verse_numbers[0]} - #{verse_numbers[-1]}: #{chapter_title}"
	end

	chapter_links << "[#{link_text}](./#{file_name}.html)  \n"
end

File.write("LINK.txt", chapter_links)

