/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
    AppRegistry,
    StyleSheet,
    Text,
    View,
    TouchableHighlight,
} from 'react-native';
import { NativeModules } from 'react-native';
import { NativeAppEventEmitter } from 'react-native';

var subscription;
var CalendarManager = NativeModules.CalendarManager;


class CustomButton extends React.Component {
  render(){
    return (
        <TouchableHighlight
            style={styles.button}
            underlayColor="#a5a5a5"
            onPress={this.props.onPress}
        >
          <Text style={styles.buttonText}>
              {this.props.text}
          </Text>
        </TouchableHighlight>
    )
  }
}

export default class IOS_RN_DEMO extends Component {

  constructor(props){
    super(props);
    this.state={
      events:'',
      notice:''
    }
  }

  componentDidMount(){
    console.log('开始订阅通知');
    subscription = NativeAppEventEmitter.addListener(
        'EventReminder',
        (reminder) => console.log('通知消息:' + reminder.name)
    )
  }

  componentWillUnmount(){
    subscription.remove();
  }

  //获取Pormise对象
  async _updateEvents(){
    try{
      var events = await CalendarManager.findEventsPromise();
      this.setState({events});
    }
    catch (e){
      console.error(e);
    }
  }

  render() {
    return (
        <View style={{marginTop:20}}>
          <Text style={styles.welcome}>
            封装ios原声模块实例
          </Text>
          <CustomButton
              text="点击调用原声模块addevent方法"
              onPress={()=>{
                CalendarManager.addEvent('生日聚会','江苏南通')
              }}
          />
          <CustomButton
              text="点击调用原声模块addevent方法"
              onPress={()=>{
                CalendarManager.addEventMoreDate('生日聚会','江苏南通',1463987752)
              }}
          />
          <CustomButton
              text="调用原生模块addEvent方法-传入字段格式"
              onPress={()=>{
                CalendarManager.addEventMoreDetails('生日聚会',{
                  location:'江苏南通',
                  time:1463987752,
                  description:'请一定准时参加'
                })
              }}
          />

          <Text style={{marginLeft:5}}>
              'callback数据' + {this.state.events}
          </Text>

          <CustomButton
              text="findEvents"
              onPress={()=>{
                CalendarManager.findEvents((events)=>{
                  if (error){
                    console.log(error);
                  }else{
                    this.setState({events:events,})
                  }
                })
              }}
          />

          <CustomButton
              text="点击调用原生模块findEventsPromise方法-Callback"
              onPress={()=> CalendarManager.findEventsPromise((error,events)=>{
                  if (error){
                    console.error(error);
                  }else {
                     this.setState({events:events,})
                  }
                })
              }
          />

          <Text style={{marginLeft:5}}>
            '静态数据为:'+{CalendarManager.firstDayOfTheWeek}
          </Text>
          <Text style={{marginLeft:5}}>
            '发送通知信息:'+{this.state.notice}
          </Text>
          <CustomButton
              text="点击调用原生模块sendNotification方法"
              onPress={()=>CalendarManager.sendNotification('准备发送通知...')}
          />

        </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});

AppRegistry.registerComponent('IOS_RN_DEMO', () => IOS_RN_DEMO);
