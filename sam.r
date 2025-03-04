# 設定要讀取的 SAM 文件路徑
input_sam_file <- "/work/u1432917/S3_NP_aligned_reads.sam"
output_sam_file <- "/work/u1432917/S3_output.sam"

# 讀取 SAM 文件
sam_data <- readLines(input_sam_file)

# 儲存結果的列表
filtered_reads <- c()

# 遍歷每一行
for (line in sam_data) {
  # 跳過標題行（以 @ 開頭的行）
  if (startsWith(line, "@")) {
    filtered_reads <- c(filtered_reads, line)  # 保留標題行
    next
  }
  
  # 分割每一行以提取 CIGAR 欄位
  fields <- strsplit(line, "\t")[[1]]
  cigar <- fields[6]  # 第六欄是 CIGAR
  
  # 檢查 CIGAR 中是否包含插入或刪除
  if (grepl("I", cigar) || grepl("D", cigar)) {
    filtered_reads <- c(filtered_reads, line)  # 儲存符合條件的 read
  }
}

# 將結果寫入新的 SAM 文件
writeLines(filtered_reads, output_sam_file)

cat("Filtered reads with insertions or deletions have been saved to:", output_sam_file, "\n")
