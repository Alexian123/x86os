void main() {
    *(short*)0xB8000 = 0x3F00 | 'C';
}
