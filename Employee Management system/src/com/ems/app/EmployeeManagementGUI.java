package com.ems.app;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

public class EmployeeManagementGUI {

    public static void main(String[] args) {
        JFrame frame = new JFrame("Employee Management System - CRUD Complete");
        frame.setSize(550, 550);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setLayout(new FlowLayout());

        // --- INPUT PANEL ---
        JPanel inputPanel = new JPanel(new GridLayout(5, 2, 5, 5));
        JTextField idField = new JTextField(15);
        JTextField nameField = new JTextField(15);
        JTextField deptField = new JTextField(15);
        JTextField salaryField = new JTextField(15);

        inputPanel.add(new JLabel("Employee ID (For Update/Delete):"));
        inputPanel.add(idField);
        inputPanel.add(new JLabel("Name:"));
        inputPanel.add(nameField);
        inputPanel.add(new JLabel("Department:"));
        inputPanel.add(deptField);
        inputPanel.add(new JLabel("Salary:"));
        inputPanel.add(salaryField);

        // --- BUTTONS PANEL ---
        JPanel buttonPanel = new JPanel();
        JButton saveBtn = new JButton("Add (C)");
        JButton viewBtn = new JButton("View (R)");
        JButton updateBtn = new JButton("Update (U)");
        JButton deleteBtn = new JButton("Delete (D)");
        
        buttonPanel.add(saveBtn);
        buttonPanel.add(viewBtn);
        buttonPanel.add(updateBtn);
        buttonPanel.add(deleteBtn);

        // --- DISPLAY AREA ---
        JTextArea displayArea = new JTextArea(15, 45);
        displayArea.setEditable(false);
        JScrollPane scrollPane = new JScrollPane(displayArea);

        // 1. CREATE ACTION (Add)
        saveBtn.addActionListener(e -> {
            try (Connection conn = DBConnection.getConnection()) {
                String sql = "INSERT INTO employees (name, department, salary) VALUES (?, ?, ?)";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, nameField.getText());
                pstmt.setString(2, deptField.getText());
                pstmt.setDouble(3, Double.parseDouble(salaryField.getText()));
                pstmt.executeUpdate();
                JOptionPane.showMessageDialog(frame, "Employee Added!");
            } catch (Exception ex) {
                JOptionPane.showMessageDialog(frame, "Error: Check your inputs!");
            }
        });

        // 2. READ ACTION (View)
        viewBtn.addActionListener(e -> {
            try (Connection conn = DBConnection.getConnection()) {
                String sql = "SELECT * FROM employees";
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql);
                displayArea.setText("ID \t Name \t Dept \t Salary\n----------------------------------------------------\n");
                while (rs.next()) {
                    displayArea.append(rs.getInt("id") + " \t " + rs.getString("name") + " \t " + 
                                       rs.getString("department") + " \t $" + rs.getDouble("salary") + "\n");
                }
            } catch (Exception ex) {
                JOptionPane.showMessageDialog(frame, "Error loading data.");
            }
        });

        // 3. UPDATE ACTION
        updateBtn.addActionListener(e -> {
            try (Connection conn = DBConnection.getConnection()) {
                String sql = "UPDATE employees SET name=?, department=?, salary=? WHERE id=?";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, nameField.getText());
                pstmt.setString(2, deptField.getText());
                pstmt.setDouble(3, Double.parseDouble(salaryField.getText()));
                pstmt.setInt(4, Integer.parseInt(idField.getText())); // Uses ID to find the right employee
                
                int rowsAffected = pstmt.executeUpdate();
                if(rowsAffected > 0) JOptionPane.showMessageDialog(frame, "Employee Updated!");
                else JOptionPane.showMessageDialog(frame, "Employee ID not found.");
            } catch (Exception ex) {
                JOptionPane.showMessageDialog(frame, "Error: Make sure ID is a number.");
            }
        });

        // 4. DELETE ACTION
        deleteBtn.addActionListener(e -> {
            try (Connection conn = DBConnection.getConnection()) {
                String sql = "DELETE FROM employees WHERE id=?";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, Integer.parseInt(idField.getText())); // Only needs ID to delete
                
                int rowsAffected = pstmt.executeUpdate();
                if(rowsAffected > 0) JOptionPane.showMessageDialog(frame, "Employee Deleted!");
                else JOptionPane.showMessageDialog(frame, "Employee ID not found.");
            } catch (Exception ex) {
                JOptionPane.showMessageDialog(frame, "Error: Please enter a valid ID to delete.");
            }
        });

        // Add to frame
        frame.add(inputPanel);
        frame.add(buttonPanel);
        frame.add(scrollPane);
        frame.setLocationRelativeTo(null);
        frame.setVisible(true);
    }
}