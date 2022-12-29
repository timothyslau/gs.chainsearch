
# FILESYSTEM --------------------------------------------------------------

# Default storage directory
#' @importFrom golem get_golem_name
#' @importFrom tools R_user_dir
storage_default <- function() {
  R_user_dir(package = get_golem_name(), which = "cache")
}

# Marker file for active storage
storage_file <- function() {
  file.path(storage_default(), "storage")
}

# Update marker file
storage_write <- function(path) {
  file <- storage_file()
  writeLines(path, file)
}

# Read marker file
storage_read <- function() {
  file <- storage_file()
  if (file.exists(file)) {
    readLines(file)
  } else {
    storage_default()
  }
}

# Set active storage
storage_set <- function(path) {
  Sys.setenv(GS_CHAINSEARCH_STORAGE = path)
}

# Get active storage
storage_get <- function() {
  Sys.getenv("GS_CHAINSEARCH_STORAGE", storage_default())
}

# Update active storage
storage_update <- function(path) {
  # Set new storage
  storage_set(path)
  storage_write(path)
  # Write key files
  proxytab_write(proxytab_get())
  proxybl_write(proxybl_get())
}

# Construct filepath within active storage
#' @importFrom fs path
storage_path <- function(..., ext = "") {
  path(storage_get(), ..., ext = ext)
}

# I/O ---------------------------------------------------------------------

#' @importFrom data.table fwrite
write_csv <- function(x, file) {
  fwrite(x, file)
}

#' @importFrom data.table fread
read_csv <- function(file) {
  fread(file = file, stringsAsFactors = FALSE, check.names = FALSE, fill = TRUE, data.table = FALSE)
}

# SESSION -----------------------------------------------------------------

# Initialize a working session
session_init <- function() {
  # Restore active storage directory
  path <- storage_read()
  storage_set(path)
  # Set proxy blacklist
  proxybl_set(proxybl_read())
  # Refresh and set proxy list
  refresh_proxy_table()
  # Set new active proxy
  proxy_set()
  # Return invisible so no tags are included
  return(invisible())
}
