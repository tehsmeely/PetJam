extends Node

enum HealthZone { BAD, FINE, GOOD, GOLD }
enum Quality { LOW, MEDIUM, HIGH }


func handle_connect_error(err: int) -> void:
	if err != OK:
		var error_name = "Unknown"
		match err:
			FAILED:
				error_name = "FAILED"

			ERR_UNAVAILABLE:
				error_name = "ERR_UNAVAILABLE"

			ERR_UNCONFIGURED:
				error_name = "ERR_UNCONFIGURED"

			ERR_UNAUTHORIZED:
				error_name = "ERR_UNAUTHORIZED"

			ERR_PARAMETER_RANGE_ERROR:
				error_name = "ERR_PARAMETER_RANGE_ERROR"

			ERR_OUT_OF_MEMORY:
				error_name = "ERR_OUT_OF_MEMORY"

			ERR_FILE_NOT_FOUND:
				error_name = "ERR_FILE_NOT_FOUND"

			ERR_FILE_BAD_DRIVE:
				error_name = "ERR_FILE_BAD_DRIVE"

			ERR_FILE_BAD_PATH:
				error_name = "ERR_FILE_BAD_PATH"

			ERR_FILE_NO_PERMISSION:
				error_name = "ERR_FILE_NO_PERMISSION"

			ERR_FILE_ALREADY_IN_USE:
				error_name = "ERR_FILE_ALREADY_IN_USE"

			ERR_FILE_CANT_OPEN:
				error_name = "ERR_FILE_CANT_OPEN"

			ERR_FILE_CANT_WRITE:
				error_name = "ERR_FILE_CANT_WRITE"

			ERR_FILE_CANT_READ:
				error_name = "ERR_FILE_CANT_READ"

			ERR_FILE_UNRECOGNIZED:
				error_name = "ERR_FILE_UNRECOGNIZED"

			ERR_FILE_CORRUPT:
				error_name = "ERR_FILE_CORRUPT"

			ERR_FILE_MISSING_DEPENDENCIES:
				error_name = "ERR_FILE_MISSING_DEPENDENCIES"

			ERR_FILE_EOF:
				error_name = "ERR_FILE_EOF"

			ERR_CANT_OPEN:
				error_name = "ERR_CANT_OPEN"

			ERR_CANT_CREATE:
				error_name = "ERR_CANT_CREATE"

			ERR_QUERY_FAILED:
				error_name = "ERR_QUERY_FAILED"

			ERR_ALREADY_IN_USE:
				error_name = "ERR_ALREADY_IN_USE"

			ERR_LOCKED:
				error_name = "ERR_LOCKED"

			ERR_TIMEOUT:
				error_name = "ERR_TIMEOUT"

			ERR_CANT_CONNECT:
				error_name = "ERR_CANT_CONNECT"

			ERR_CANT_RESOLVE:
				error_name = "ERR_CANT_RESOLVE"

			ERR_CONNECTION_ERROR:
				error_name = "ERR_CONNECTION_ERROR"

			ERR_CANT_ACQUIRE_RESOURCE:
				error_name = "ERR_CANT_ACQUIRE_RESOURCE"

			ERR_CANT_FORK:
				error_name = "ERR_CANT_FORK"

			ERR_INVALID_DATA:
				error_name = "ERR_INVALID_DATA"

			ERR_INVALID_PARAMETER:
				error_name = "ERR_INVALID_PARAMETER"

			ERR_ALREADY_EXISTS:
				error_name = "ERR_ALREADY_EXISTS"

			ERR_DOES_NOT_EXIST:
				error_name = "ERR_DOES_NOT_EXIST"

			ERR_DATABASE_CANT_READ:
				error_name = "ERR_DATABASE_CANT_READ"

			ERR_DATABASE_CANT_WRITE:
				error_name = "ERR_DATABASE_CANT_WRITE"

			ERR_COMPILATION_FAILED:
				error_name = "ERR_COMPILATION_FAILED"

			ERR_METHOD_NOT_FOUND:
				error_name = "ERR_METHOD_NOT_FOUND"

			ERR_LINK_FAILED:
				error_name = "ERR_LINK_FAILED"

			ERR_SCRIPT_FAILED:
				error_name = "ERR_SCRIPT_FAILED"

			ERR_CYCLIC_LINK:
				error_name = "ERR_CYCLIC_LINK"

			ERR_INVALID_DECLARATION:
				error_name = "ERR_INVALID_DECLARATION"

			ERR_DUPLICATE_SYMBOL:
				error_name = "ERR_DUPLICATE_SYMBOL"

			ERR_PARSE_ERROR:
				error_name = "ERR_PARSE_ERROR"

			ERR_BUSY:
				error_name = "ERR_BUSY"

			ERR_SKIP:
				error_name = "ERR_SKIP"

			ERR_HELP:
				error_name = "ERR_HELP"

			ERR_BUG:
				error_name = "ERR_BUG"

			ERR_PRINTER_ON_FIRE:
				error_name = "ERR_PRINTER_ON_FIRE"
		assert(false, "Error connecting: %s" % error_name)
