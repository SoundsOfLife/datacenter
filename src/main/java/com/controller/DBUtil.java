package com.controller;
import org.apache.commons.dbcp2.cpdsadapter.DriverAdapterCPDS;
import org.apache.commons.dbcp2.datasources.SharedPoolDataSource;

import java.sql.*;

/**
 * Created by THINK on 2015/4/22.
 */
public class DBUtil {
    private final static String DRIVERNAME = "com.mysql.jdbc.Driver";
    private final static String URL = "jdbc:mysql://127.0.0.1:3306/test";
    private final static String USERNAME = "root";
    private final static String PASSWORD = "zlp951116";

    public static Connection getConnection(){
        Connection connection = null;
        try{
            Class.forName(DRIVERNAME);
            connection = DriverManager.getConnection(URL,USERNAME,PASSWORD);
        }catch(Exception e){
            e.printStackTrace();
        }
        return connection;
    }

    public static Statement getStatement(Connection connection){
        Statement statement = null;
       if(connection != null){
           try{
               return connection.createStatement();
           }catch (Exception e){
               e.printStackTrace();
           }
       }
      return statement;
    }

    public static ResultSet getResultSet(Statement statement,String sql){
        ResultSet resultSet = null;
        try{
            if(statement != null){
                resultSet = statement.executeQuery(sql);
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return resultSet;
    }

    public static Connection getConnectionByPool(){
        Connection connection = null;

        try{
            DriverAdapterCPDS cpds = new DriverAdapterCPDS();
            cpds.setDriver(DRIVERNAME);
            cpds.setUrl(URL);
            cpds.setUser(USERNAME);
            cpds.setPassword(PASSWORD);

            SharedPoolDataSource tds = new SharedPoolDataSource();
            tds.setConnectionPoolDataSource(cpds);

            connection = tds.getConnection();
        }catch (Exception e){
            e.printStackTrace();
        }

        return connection;
    }

    public static void closeResultSet(ResultSet resultSet){
        try{
            if(resultSet != null){
                resultSet.close();
            }
        }catch (Exception e){
            e.printStackTrace();
        }
    }
    public static void closeStatement(Statement statement){
        try{
            if(statement != null){
                statement.close();
            }
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    public static void closeConnection(Connection connection){
        try{
            if(connection != null) {
                connection.close();
            }
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    public static void closePreparedStatement(PreparedStatement pStatement){
        try{
            if(pStatement != null){
                pStatement.close();
            }
        }catch (Exception e){
            e.printStackTrace();
        }
    }
}
