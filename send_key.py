#!/usr/bin/env python3

import fcntl
import os
import sys
import termios


def inject_bytes_to_tty(bytes_to_inject, tty_path="/dev/tty") -> bool:
    """
    Inject raw bytes into the controlling terminal's input buffer.
    This emulates the user typing the bytes into the current terminal.
    """
    try:
        with open(tty_path, "wb", buffering=0) as tty:
            fd = tty.fileno()
            for byte_value in bytes_to_inject:
                fcntl.ioctl(fd, termios.TIOCSTI, bytes([byte_value]))
        return True
    except Exception as exc:
        sys.stderr.write(f"Error injecting keys: {exc}\n")
        return False


def main() -> None:
    # Sequence: tmux prefix (Ctrl-b), then Alt+Shift+P
    # Ctrl-b -> 0x02
    # Alt+Shift+P -> ESC (0x1B) followed by 'P'
    key_sequence = [0x02, 0x1B, ord("P")]

    # Optional: warn if not inside tmux (still injects to terminal)
    # if os.getenv("TMUX") is None:
    #     sys.stderr.write("Warning: TMUX not detected; injecting keys anyway.\n")

    ok = inject_bytes_to_tty(key_sequence)
    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main()
