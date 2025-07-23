package com.todo.todo.service;

import com.todo.todo.model.Todo;
import com.todo.todo.repository.TodoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TodoService {
    @Autowired
    private TodoRepository repo;

    public List<Todo> findAll() {
        return repo.findAll();
    }

    public Todo save(Todo todo) {
        return repo.save(todo);
    }

    public void delete(Long id) {
        repo.deleteById(id);
    }
}
