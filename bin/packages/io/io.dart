library io;

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

part 'common.dart';
//part 'file.dart'; -- stubbed class FileSystemException from there
//part 'file_system_entity.dart'; -- I need to stop eventually; decided to stop here.
part 'io_sink.dart';
part 'socket.dart';

//file.dart

/**
 * Exception thrown when a file operation fails.
 */
class FileSystemException implements IOException {
  /**
   * Message describing the error. This does not include any detailed
   * information form the underlying OS error. Check [osError] for
   * that information.
   */
  final String message;

  /**
   * The file system path on which the error occurred. Can be `null`
   * if the exception does not relate directly to a file system path.
   */
  final String path;

  /**
   * The underlying OS error. Can be `null` if the exception is not
   * raised due to an OS error.
   */
  final OSError osError;

  /**
   * Creates a new FileSystemException with an optional error message
   * [message], optional file system path [path] and optional OS error
   * [osError].
   */
  const FileSystemException([this.message = "", this.path = "", this.osError]);

  String toString() {
    StringBuffer sb = new StringBuffer();
    sb.write("FileSystemException");
    if (!message.isEmpty) {
      sb.write(": $message");
      if (path != null) {
        sb.write(", path = '$path'");
      }
      if (osError != null) {
        sb.write(" ($osError)");
      }
    } else if (osError != null) {
      sb.write(": $osError");
      if (path != null) {
        sb.write(", path = '$path'");
      }
    } else if (path != null) {
      sb.write(": $path");
    }
    return sb.toString();
  }
}
