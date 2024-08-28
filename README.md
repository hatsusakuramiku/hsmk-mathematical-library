// Initialize a stack and return a pointer to it
Stack* stackInit() {
// Allocate memory for the stack
Stack* stack = (Stack*)malloc(sizeof(Stack));
// If memory allocation fails, return a NULL pointer
if (stack == NULL) {
PWARNING_RETURN_MALLOC(stack);
}
// Set the head of the stack to NULL
stack->head = NULL;
// Set the size of the stack to 0
stack->size = 0;
// Return the pointer to the initialized stack
return stack;
}
// Initialize a stack and return a pointer to it
Stack* stackInit() {
// Allocate memory for the stack
Stack* stack = (Stack*)malloc(sizeof(Stack));
// If memory allocation fails, return a NULL pointer
if (stack == NULL) {
PWARNING_RETURN_MALLOC(stack);
}
// Set the head of the stack to NULL
stack->head = NULL;
// Set the size of the stack to 0
stack->size = 0;
// Return the pointer to the initialized stack
return stack;
}