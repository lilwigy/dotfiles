; extends

; bullet points
([(list_marker_plus) (list_marker_minus) (list_marker_star) (list_marker_dot)] @punctuation.special (#offset! @punctuation.special 0 0 0 -1) (#set! conceal "•"))

; Checkbox list items
((task_list_marker_unchecked) @task_list_marker_unchecked (#set! conceal ""))
((task_list_marker_checked) @task_list_marker_checked (#set! conceal ""))
(list_item (task_list_marker_checked)) @task_list_marker_checked
(list_item (task_list_marker_unchecked)) @task_list_marker_unchecked

; Use box drawing characters for tables
(pipe_table_header ("|") @punctuation.special @conceal (#set! conceal "┃"))
(pipe_table_delimiter_row ("|") @punctuation.special @conceal (#set! conceal "┃"))
(pipe_table_delimiter_cell ("-") @punctuation.special @conceal (#set! conceal "━"))
(pipe_table_row ("|") @punctuation.special @conceal (#set! conceal "┃"))
(pipe_table_header (pipe_table_cell) @pipe_table_header)

; Block quotes
;((block_quote_marker) @block_quote_marker (#offset! @block_quote_marker 0 0 0 -1) (#set! conceal "▐"))
;((block_continuation) @block_quote_marker (#eq? @block_quote_marker "> ") (#offset! @block_quote_marker 0 0 0 -1) (#set! conceal "▐"))
;((block_continuation) @block_quote_marker (#eq? @block_quote_marker ">") (#set! conceal "▐"))
;(block_quote (paragraph) @text.literal)


