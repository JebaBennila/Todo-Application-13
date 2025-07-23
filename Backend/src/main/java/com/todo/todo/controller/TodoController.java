package com.todo.todo.controller;

import com.todo.todo.model.Todo;
import com.todo.todo.repository.TodoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/todos")
@CrossOrigin(origins = "*") 
public class TodoController {
    @Autowired
    private TodoRepository todoRepository;
    @GetMapping
    public List<Todo> getAllTodos() {
        return todoRepository.findAll();
    }
    @PostMapping
    public Todo createTodo(@RequestBody Todo todo) {
        todo.setId(null); 
        return todoRepository.save(todo);
    }
    @PutMapping("/{id}")
    public Todo updateTodo(@PathVariable Long id, @RequestBody Todo todo) {
        todo.setId(id); 
        return todoRepository.save(todo);
    }
    @DeleteMapping("/{id}")
    public void deleteTodo(@PathVariable Long id) {
        todoRepository.deleteById(id);
    }
}
