package com.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import java.beans.Statement;
import java.lang.Class;
import java.lang.Exception;
import java.sql.Connection;
import java.sql.ResultSet;
import java.util.ArrayList;

@Controller
@RequestMapping("/com/controller")
public class DataController {
	@RequestMapping("/resolveJson")
	public void getJson(HttpServletRequest request,HttpServletResponse response) throws Exception{
		String str = request.getParameter("json");
		ArrayList<Data> arrayList = new ArrayList<Data>();
		Connection connection = DBUtil.getConnection();
		Statement statement = connection.prepareStatement();
		ResultSet rs = statement.execute();
		while(rs.next()){
			Data data = new Data();
			data.setTime(rs.getString(1));
			data.setContext(rs.getString(2));
			data.setPlcae(rs.getString(3));
			data.setPiece(rs.getString(4));
			data.setRes(rs.getString(5));
			arrayList.add(data);
		}

		JsonArray jsons = new JsonArray();
		for(int j = 0;j < arrayList.size();j++){
			JSONObject jsonObject = new JSONObeject();
			jsonObject.put("data",arrayList.get(j));
			jsons.add(jsonObject);
		}
		response.getWriter().print(jsons.toString());
	}
}
