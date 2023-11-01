#include <textio.h>
#include <sys.h>

void main(void) {
    idt_install();
    isrs_install();
    set_bg_color(PURPLE);
    set_text_color(YELLOW);
    print_str("Hello, World!");
    for (;;);
}
