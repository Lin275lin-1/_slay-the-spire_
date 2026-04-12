class_name IncidentData
extends Resource

#该事件属于第几阶段
enum Stage{
	All,		#全部阶段都有可能发生的事件
	First,
	Second,
	Third
}

#事件属性
#背景图资源地址
@export var backgroundPath:String
#事件名称（英文）
@export var incidentName:String
#事件发生的阶段
@export var stage:Stage

#事件标题（中文）
@export var eventTitile: String = ""
#事件描述
@export_multiline var eventDescription: String = ""
#按钮1描述
@export_multiline var option1Description:String=""
#按钮2描述
@export_multiline var option2Description:String=""

#选择按钮以后的信息
@export_multiline var press_op1_title:Array[String]
@export_multiline var press_op1_description:Array[String]
@export_multiline var press_op1_op1description:Array[String]
@export_multiline var press_op1_op2description:Array[String]

@export_multiline var press_op2_title:Array[String]
@export_multiline var press_op2_description:Array[String]
@export_multiline var press_op2_op1description:Array[String]
@export_multiline var press_op2_op2description:Array[String]
