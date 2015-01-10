package main

//********************************
// 导入依赖包
//********************************
import (
	"fmt"
	"net"
	"os"
	"bytes"
	"encoding/binary"
//	"bufio"
//	"encoding/binary"
)

//********************************
// 初始化常量
//********************************
const (
	MAX_CONN_NUM = 50000
	HOST_PORT    = "0.0.0.0:8088"
	PROTOCOL     = "tcp"

	//业务
	SEND_ROOM_ACTION  = 5    //房间动作			C2S | S2C
	SEND_USER_ACTION  = 7    //用户动作			C2S	| S2C
	UPDATE_USER       = 6    //更新用户			C2S	| S2C
	CHAT              = 8    //聊天				C2S	| S2C
	RPC               = 9    //远程调用			C2S	| S2C
	ACQUIRE_TOKEN     = 11   //令牌				C2S	| S2C
	PING              = 0XFB //心跳					  S2C
	PONG              = 0XFC //心跳			    C2S
	RES_REPEAT        = 0XFD //远程登录			      S2C
	RES_RECORD        = 13   //录制					  S2C
	RES_RECORD_INFO   = 14   //录制状态				  S2C
	RES_TOKEN_CHANGED = 12   //令牌改变				  S2C
	RES_JOIN_ROOM     = 1    //加入房间				  S2C
	RES_USER_IN       = 2    //用户进入				  S2C
	RES_USER_OUT      = 3    //用户退出			      S2C
	RES_LOGIN         = 0    //回复登陆				  S2C
	REQ_RECORD        = 13   //请求录制			C2S
	REQ_LOGIN         = 11   //请求登陆			C2S
	REQ_JOIN_ROOM     = 1    //请求加入房间		C2S
	REQ_LOGOUT        = 10   //请求退出			C2S
)

//********************************
// 房间
//********************************
type Room struct {
	id    string
	users []net.Conn
}

//********************************
// 广播
//********************************
type broadcast struct {
	room_id string
	data []byte
}

//********************************
// 业务逻辑
// TODO
//********************************
type packetHandler func([]byte, net.Conn)

//********************************
// 登陆
// TODO
//********************************
func handleLogin(pkg []byte, conn net.Conn) {
	//TODO
	println("handle login request packet")
	//FIXME:不需要验证，直接返回登陆成功
	buff := bytes.NewBuffer(make([]byte, 0))
	err := binary.Write(buff, binary.LittleEndian, uint8(RES_LOGIN))
	if err != nil {
		fmt.Println("binary.Write failed:", err)
	}
	err = binary.Write(buff, binary.LittleEndian, uint32(5))//len(ok+sid)
	if err != nil {
		fmt.Println("binary.Write failed:", err)
	}
	err = binary.Write(buff, binary.LittleEndian, uint8(0))//OK
	if err != nil {
		fmt.Println("binary.Write failed:", err)
	}
	err = binary.Write(buff, binary.LittleEndian, uint32(10086))//sid
	if err != nil {
		fmt.Println("binary.Write failed:", err)
	}
	conn.Write(buff.Bytes())
}
func handleRecord(pkg []byte, conn net.Conn) {
	//TODO
	println("handle record packet")
}

//********************************
// 加入房间
// TODO
//********************************
func handleJoinRoom(pkg []byte, conn net.Conn) {
	//TODO
	println("handle join room packet")

	//FIXME:不需要验证，直接加入房间
	buff := bytes.NewBuffer(make([]byte, 0))
	err := binary.Write(buff, binary.LittleEndian, uint8(RES_JOIN_ROOM))
	if err != nil {
		fmt.Println("binary.Write failed:", err)
	}
	err = binary.Write(buff, binary.LittleEndian, uint32(17))
	if err != nil {
		fmt.Println("binary.Write failed:", err)
	}
	err = binary.Write(buff, binary.LittleEndian, uint8(0))//video_id，没有则为0，否则为video_id
	if err != nil {
		fmt.Println("binary.Write failed:", err)
	}
	err = binary.Write(buff, binary.LittleEndian, uint32(5))//user_count，如果大于0，则需要写入user_count个id、sid
	if err != nil {
		fmt.Println("binary.Write failed:", err)
	}

	//如果用户数量大于0，则在此写入各个用户的id、sid
	// while user_count--
	// write user.id
	// write user.sid

	//为当前用户生成sid
	err = binary.Write(buff, binary.LittleEndian, uint32(10086))//sid，必须保证唯一
	if err != nil {
		fmt.Println("binary.Write failed:", err)
	}

	//写入房间数据长度
	err = binary.Write(buff, binary.LittleEndian, uint32(0))//房间数据长度
	if err != nil {
		fmt.Println("binary.Write failed:", err)
	}

	//写入房间动作长度
	err = binary.Write(buff, binary.LittleEndian, uint32(0))//房间动作长度
	if err != nil {
		fmt.Println("binary.Write failed:", err)
	}

	//房间数据长度如果大于0，则写入房间数据，具体格式未知
	//目前已知的字段
	//version-uint32
	//nextActionId-uint32
	//nextObjectId-uint32
	//一组object-未知
	//room_action_count-uint32
	//一组room_action，用两字节数据分割
	//

	conn.Write(buff.Bytes())
}
func handleLogout(pkg []byte, conn net.Conn) {
	//TODO
	println("handle logout packet")
}
func handleSendRoomAction(pkg []byte, conn net.Conn) {
	//TODO
	println("handle send room action packet")
}
func handleSendUserAction(pkg []byte, conn net.Conn) {
	//TODO
	println("handle send user action packet")
}
func handleUpdateUser(pkg []byte, conn net.Conn) {
	//TODO
	println("handle update user packet")
}
func handleChat(pkg []byte, conn net.Conn) {
	//TODO
	println("handle chat packet")
}
func handleRPC(pkg []byte, conn net.Conn) {
	//TODO
	println("handle RPC packet")
}
func handleAcquireToken(pkg []byte, conn net.Conn) {
	//TODO
	println("handle acquire token packet")
}
func handlePong(pkg []byte, conn net.Conn) {
	//TODO
	println("handle pong packet")
}

//********************************
// 客户端连接预处理
// TODO
// 参数说明：
// handlers -> 处理不同类型的请求
// rooms 	-> 所有的房间(map是引用传递)
// bc_chan  -> 用于广播的chan
// conn 	-> 当前客户端连接
//********************************
func handleConn(handlers map[uint32]packetHandler, rooms map[string]Room, bc chan broadcast, conn net.Conn) {
	defer conn.Close()
	println(conn.RemoteAddr().String(), "connected")

	//	uid := conn.RemoteAddr().String();

	//1024不确定
	buf := make([]byte, 1024)
	for {
		len, err := conn.Read(buf)

		if err != nil {
			return
		}else {
			_type := uint32(buf[0])
			//登陆请求与抢令牌请求用的同一个type(遗留问题)，需要特殊判断
			if len == 5 && _type == 11 {
				//抢令牌
				handlers[_type + 9](nil, conn)
			}else if _, ok := handlers[_type]; ok {
				handlers[_type](buf[2:], conn)
			}else {
				println("wrong packet ", _type)
			}
		}

		//FIXME:并不是都需要广播
//		bc_info := broadcast{"za", buf}
//		bc <- bc_info
	}
}

//********************************
// 程序入口函数
// 初始化
//********************************
func main() {

	var handlers map[uint32]packetHandler
	handlers = make(map[uint32]packetHandler)
	handlers[REQ_LOGIN] = handleLogin
	handlers[REQ_JOIN_ROOM] = handleJoinRoom
	handlers[REQ_LOGOUT] = handleLogout
	handlers[REQ_RECORD] = handleRecord
	handlers[PONG] = handlePong
	handlers[ACQUIRE_TOKEN+9] = handleAcquireToken//为了与login包区别
	handlers[CHAT] = handleChat
	handlers[RPC] = handleRPC
	handlers[SEND_ROOM_ACTION] = handleSendRoomAction
	handlers[SEND_USER_ACTION] = handleSendUserAction
	handlers[UPDATE_USER] = handleUpdateUser

	//所有房间
	var rooms map[string]Room
	rooms = make(map[string]Room)

	//广播通道
	var bc_chan chan broadcast
	bc_chan = make(chan broadcast)

	//监听广播通道
	go func() {
		for {
			select {
			case _, ok := <-bc_chan:
				if ok{
//					println("broadcast room id", bc.room_id)
//					println("broadcast data", bc.data)
//					room, ok := rooms[bc.room_id]
//					if ok {
//						println("find room", bc.room_id)
//						if room.id == bc.room_id{
//							for i, v := range room.users{
//								println("i v", i, v)
//								if v != nil{
//									v.Write(bc.data)
//								}
//							}
//						}else{
//							println("wrong，room id not the same", room.id, bc.room_id)
//						}
//						room
//					}else{
//						println("can't find room", bc.room_id)
//					}
				}
			}
		}
	}()

	listener, err := net.Listen(PROTOCOL, HOST_PORT)
	if err != nil {
		fmt.Println("error listening:", err.Error())
		os.Exit(1)
	}

	defer listener.Close()

	fmt.Printf("running at %s \n", HOST_PORT)

	for {
		conn, err := listener.Accept()
		if err != nil {
			println("Error accept:", err.Error())
			return
		}

		//FIXME:需要连接池
		go handleConn(handlers, rooms, bc_chan, conn)
	}
}
