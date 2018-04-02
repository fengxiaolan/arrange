import React from 'react'
import PropTypes from 'prop-types'

import Formsy, {withFormsy} from 'formsy-react';
import FlatButton from 'material-ui/FlatButton'
import Checkbox from 'material-ui/Checkbox';

import md5 from './md5'
import ErrorNotice from './controls/errorNotice';
import LoadingButton from './controls/loadingButton';
import PasswordInput from './controls/passwordInput';
import TextInput from './controls/textInput';

import {getTranslateRecords, translate} from '../services/translator';

import {setLayout} from '../model/workspaceStore';
import {setLoginAccount, setWatchList} from '../model/user';
import validationRules from 'formsy-react/lib/validationRules'

import {
    queueLoginRequest,
    queueLastLoginPasswordRequest,
    queueQueryWorkSpaceRequest,
    queueQueryWatchListRequest
} from '../services/serviceEventBus';

import {BLUE_LIGHT, BLUE, BLUE_500, GREY_54, GREY_82, WHITE, GREY_48, GREY_189, RED_500, GREY_68} from '../colors';

const FormsyCheckbox = withFormsy(Checkbox);

export default class LoginPanel extends React.PureComponent {
    static propTypes = {
        onPasswordReset: PropTypes.func.isRequired,
        onNewUser      : PropTypes.func.isRequired,
    };
    
    state = {
        isSubmitting: false,
        canSubmit   : false,
        alertMsg    : '',
        loginInfo   : {},
        isUserInput : false,
        keepPassword: false,
        idx         : -1,
        userIDvalid : true,
        oldpassword : true
    };
    
    submitForm = (form) =>
    {
        this.setState({isSubmitting: true, alertMsg: '', canSubmit: false, loginProgress: 0}, () =>
        {
            
            if (form.password !== this.state.lastLoginPassword)
                form.password = md5(form.password, true);
            
            console.info(form);
            
            queueLoginRequest(form.userID, form.password, this.state.keepPassword, this.onLoginProgress)
                .then(response =>
                      {
                    
                          const accountProto = response.account,
                        
                              workspacePromise = queueQueryWorkSpaceRequest(accountProto.accountID)
                                  .then(workspaceList =>
                                        {
                                            workspaceList.forEach(w => setLayout(w.layoutID, w.windowList));
                                        }),
                        
                              watchListPromise = queueQueryWatchListRequest(accountProto.accountID)
                                  .then(responseProto =>
                                        {
                                            const list = responseProto.watchList;
                                
                                            if (list)
                                                list.record.forEach(setWatchList);
                                        });
                    
                          return Promise.all([workspacePromise, watchListPromise])
                              .then(() =>
                                    {
                            
                                        this.setState({isSubmitting: false, canSubmit: true});
                            
                                        setLoginAccount(accountProto);
                                    });
                      })
                .catch(result =>
                       {
                           console.info(result);
                           this.setState({isSubmitting: false, canSubmit: true, alertMsg: result.toString()});
                       });
        });
    };
    
    onLoginProgress = (countDown) =>
    {
        this.setState({loginProgress: countDown});
    };
    
    onUserInput = () =>
    {
        const {isUserInput} = this.state;
        
        if (!isUserInput)
            this.setState({isUserInput: true});
    };
    
    requestPwdReset = () => {this.props.onPasswordReset();};
    
    requestNewUser = () => {this.props.onNewUser();};
    
    onMouseEnter(index)
    {
        this.setState({idx: index});
    };
    
    onMouseLeave = () =>
    {
        this.setState({idx: -1})
    };
    
    updateCheck = (event, value) =>
    {
        this.setState({keepPassword: value});
    };
    
    componentWillMount()
    {
        queueLastLoginPasswordRequest().then(record =>
                                             {
            
                                                 if (!this.state.isUserInput && record)
                                                 {
                                                     this.setState({
                                                                       loginInfo        : {...record, keepLoginInfo: true},
                                                                       lastLoginPassword: record.password
                                                                   });
                                                 }
                                             });
    }
    
    render()
    {
        const translates = getTranslateRecords(),
            
            isSubmitting = this.state.isSubmitting,
            
            resetBtn = {
                onTouchTap: this.requestPwdReset,
                label     : translates.FORGET_PASSWORD,
                disabled  : isSubmitting,
                labelStyle: {
                    textTransform: 'none',
                    fontSize     : 14,
                    fontWeight   : 300,
                    color        : BLUE_500
                },
                style     : {height: 36, margin: '30px 0 0', float: 'right'}
            },
            
            loginInfo = this.state.loginInfo,
            
            checkBox = {
                checkStyle: {
                    marginTop: 70
                },
                
                checkIconStyle: {
                    width      : 14,
                    height     : 14,
                    marginRight: 9,
                    marginTop  : 2,
                    color      : WHITE
                    
                },
                
                checkLabelStyle: {
                    fontSize  : 14,
                    fontWeight: 300,
                    color     : WHITE
                },
                
                checkRippleStyle: {
                    top : -8,
                    left: -8
                }
            },
            
            loginBtn = {
                className         : "center fullWidth",
                type              : "submit",
                label             : translates.LOGIN,
                labelStyle        : {fontSize: 16, fontWeight: 300},
                disabled          : !this.state.canSubmit,
                backgroundColor   : GREY_68,
                disabledLabelColor: WHITE,
                color             : WHITE,
                style             : {
                    marginTop   : 20,
                    marginBottom: 34,
                    height      : 46
                }
            },
            
            newUserBtn = {
                onTouchTap        : this.requestNewUser,
                label             : translates.CREATE_NEW_ACCOUNT,
                disabled          : isSubmitting,
                labelStyle        : {
                    textTransform: 'none',
                    fontSize     : 14,
                    fontWeight   : 300,
                    paddingLeft  : 0,
                    lineHeight   : '20px',
                    paddingLeft  : 0,
                    color        : this.state.idx === 1 ? BLUE_LIGHT : BLUE_500
                },
                style             : {height: 24},
                disableTouchRipple: true,
                hoverColor        : GREY_48
            }
        ;
        
        // let value = this.state.checked;
        // if(typeof value === 'undefined'){
        //
        //     value = typeof loginInfo.keepLoginInfo !=='undefined' ? loginInfo.keepLoginInfo : false
        // }
        
        // let value;
        // if (typeof value === 'undefined') {
        //     value = (typeof loginInfo.keepLoginInfo !== 'undefined') ? loginInfo.keepLoginInfo : false;
        // }
        
        return <Formsy method="post"
                       autoComplete="off"
                       disabled={isSubmitting}
                       onValid={() => this.setState({canSubmit: true})}
                       onInvalid={() => this.setState({canSubmit: false})}
                       onValidSubmit={this.submitForm}
                       onChange={(vals, isChanged) =>
                       {
                           isChanged && this.onUserInput();
                           this.setState({
                                             userIDvalid: !!validationRules.isAlphanumeric('userID', vals.userID),
                                             oldpassword: !!validationRules.minLength('password', vals.password, 6)
                                         })
                       }}>
            
            <TextInput name="userID"
                       type="text"
                       value={loginInfo.userID}
                       disabled={isSubmitting}
                       validations={{
                           myCustomIsFiveValidation: function (values, value) {
                               return 'error ';
                           }
                       }}
                       hintText={translates.ACCOUNT_HINT}
                       valid={this.state.userIDvalid}
                       errorText={translates.INVALID_ACCOUNT_ID}
                       style={{marginTop: 8, marginBottom: 8}}
            />
            
            <PasswordInput name="password"
                           hintText={translates.PASSWORD_HINT}
                           disabled={isSubmitting}
                           password={loginInfo.password}
            />
            
            <ErrorNotice style={{fontSize: 12, lineHeight: '17px', margin: '4px 0 0', position: 'absolute'}}>
                {this.state.alertMsg ? translate('LOGIN_ERROR', this.state.alertMsg) : ''}
            </ErrorNotice>
            
            <FlatButton {...resetBtn}
                        onMouseEnter={() => this.onMouseEnter(0)}
                        onMouseLeave={this.onMouseLeave}
            />
            
            <Checkbox name="keepLoginInfo"
                      disabled={isSubmitting}
                      value={loginInfo.keepLoginInfo}
                      label={translates.KEEPPWD_HINT}
                      labelStyle={checkBox.checkLabelStyle}
                      iconStyle={checkBox.checkIconStyle}
                      style={checkBox.checkStyle}
                //checked={this.state.checked ? (typeof loginInfo.keepLoginInfo === 'undefined' ?  : false}
                      onCheck={this.updateCheck}
                      rippleStyle={checkBox.checkRippleStyle}
            />
            
            <LoadingButton searchProgress={this.state.loginProgress}
                           button={loginBtn}
            />
            
            <FlatButton {...newUserBtn}
                        onMouseEnter={() => this.onMouseEnter(1)}
                        onMouseLeave={this.onMouseLeave}
            />
        
        </Formsy>;
    }
}













textInput


import React, {PureComponent} from 'react';

import {withFormsy} from 'formsy-react';
import TextField from 'material-ui/TextField';

import IconButton from 'material-ui/IconButton';
import FontIcon from 'material-ui/FontIcon';
import debounce from 'lodash/debounce';

import {WHITE, RED_500, WHITE_DARK, GREY_97, GREEN_500, BLUE, GREY_189, GREY_117, BLUE_500} from '../../colors';

const
    defaultLeftIconStyle = {
        fontSize  : 12,
        color     : WHITE,
        textAlign : 'center',
        width     : 12,
        height    : 12,
        lineHeight: '12px'
    },
    
    defaultLeftStyle = {
        position: 'absolute',
        float   : 'left',
        width   : 12,
        height  : 12,
        padding : 0,
        bottom  : 16,
        left    : 1
    },
    
    defaultRightIconStyle = {
        fontSize       : 9,
        fontWeight     : 'bold',
        color          : WHITE,
        textAlign      : 'center',
        backgroundColor: RED_500,
        borderRadius   : '50%',
        width          : 12,
        height         : 12,
        marginLeft     : -2,
        lineHeight     : '12px'
    },
    
    defaultRightStyle = {
        position: 'absolute',
        float   : 'right',
        width   : 14,
        height  : 14,
        padding : 0,
        bottom  : 16,
        right   : 1
    }
;

class TextInput extends PureComponent {
    
    state = {
        value: null,
        focus: false
    };
    
    onFocus = () =>
    {
        this.setState({
                          focus: true
                      });
        
    };
    
    debounceOnBlur = debounce(() =>
                              {
                                  if (this.state.value.length === 0)
                                  {
                                      this.setState({value: ''});
                                  }
        
                                  this.setState({focus: false});
                              }
        , 300);
    
    handleChange = (event) =>
    {
        this.setState({value: event.target.value});
    };
    
    handleClear = () =>
    {
        const {value} = this.props;
        
        if (value || this.state.value)
        {
            this.setState({
                              value: ''
                          });
        }
        
    };
    
    onKeyDown = (keyEvent) =>
    {
        const {keyCode} = keyEvent;
        
        if (keyCode === 13)
        {
            if (keyEvent.target.value !== '')
                this.setState({focus: false});
        }
    };
    
    /** textInput need props
     * pararent params : style, hintText, name, disabled, validations, validationError
     * default params : hintStyle , underlineFocusStyle, underlineStyle , inputStyle
     * judge leftIcon  offer  leftIcon={true}  but  rightIcon  is all exist
     * rightBtn default params :  iconRightElement, clearStyle, clearIconStyle
     * leftBtn default params :  iconLeftElement, leftStyle, leftIconStyle
     */
    
    
    render()
    {
        const {
                type, hintText, name, disabled, onLeftClick, value, className, valid, validationError,
                validations,
                
                style = {marginBottom: 8},
                
                hintStyle = {fontSize: 14, color: GREY_189, fontWeight: 300},
                
                underlineFocusStyle = {borderColor: BLUE_500},
                
                underlineStyle = {borderColor: GREY_117},
                
                underlineCompStyle = {borderColor: GREY_117, borderBottomWidth: 2},
                
                inputStyle = {fontSize: 14, color: WHITE},
                
                //errorStyle          = {fontSize: 16, lineHeight: '16px'},
                errorStyle,
                
                iconRightElement = <FontIcon className="material-icons">clear</FontIcon>,
                
                rightStyle = {},
                
                rightIconStyle = {},
                
                iconLeftElement,
                
                leftStyle = {},
                
                leftIconStyle = {},
    
            getErrorMessage,
                
            } = this.props,
            
            errorText = getErrorMessage ? getErrorMessage() : '',
            
            values = this.state.value !== null ? this.state.value : value,
            
            rightBtn = (values && this.state.focus) ? <IconButton style={{...defaultRightStyle, ...rightStyle}}
                                                                  iconStyle={{...defaultRightIconStyle, ...rightIconStyle}}
                                                                  onClick={this.handleClear}
                                                                  children={iconRightElement}
            ></IconButton> : "",
            
            leftBtn = iconLeftElement ? <IconButton style={{...defaultLeftStyle, ...leftStyle}}
                                                    iconStyle={{...defaultLeftIconStyle, ...leftIconStyle}}
                                                    onClick={onLeftClick}
                                                    children={iconLeftElement}
            ></IconButton> : "";
        
        return <div style={{position: 'relative'}}>
            
            <TextField
                // fullWidth={true}
                // type={type}
                // value={values}
                // name={name}
                // className={className}
                // required
                // ref={ref => this.input = ref}
                // hintText={hintText}
                // hintStyle={hintStyle}
                // disabled={disabled}
                // validationColor={validationColor}
                // errorStyle={errorStyle}
                // underlineFocusStyle={underlineFocusStyle}
                // underlineStyle={underlineStyle}
                // inputStyle={inputStyle}
                validations={validations}
                validationError={validationError}
                // style={style}
                // onFocus={this.onFocus}
                // onBlur={this.debounceOnBlur}
                // onChange={this.handleChange}
                // onKeyDown={this.onKeyDown}
                
                ref={ref => this.input = ref}
                fullWidth={true}
                type={type}
                value={values}
                name={name}
                className={className}
                required
                hintText={hintText}
                hintStyle={hintStyle}
                disabled={disabled}
                errorText={errorText}
                underlineFocusStyle={underlineFocusStyle}
                underlineStyle={underlineStyle}
                inputStyle={inputStyle}
                style={style}
                onChange={this.handleChange}
                onKeyDown={this.onKeyDown}
            />
        </div>;
    }
};

export default withFormsy(TextInput);








内部获取错误  passwordInput 


import React, {PureComponent} from 'react';
import PropTypes from 'prop-types';

import {getTranslateRecords} from '../../services/translator';
import LinearProgress from 'material-ui/LinearProgress';

import {withFormsy} from 'formsy-react';
import TextField from 'material-ui/TextField';

import {
    GREEN_A400,
    GREEN_A700,
    WHITE,
    RED_A100,
    RED_A200,
    RED_A700,
    GREY_189
} from '../../colors';
import debounce from 'lodash/debounce';
import zxcvbn from 'zxcvbn'
import {FONT_NORMAL} from "../../font";
import validationRules from 'formsy-react/lib/validationRules';

const FormsyText = withFormsy(TextField);

const strengthLevels = {
    0: 'PWD_EASIEST',
    1: 'PWD_EASIER',
    2: 'PWD_EASY',
    3: 'PWD_SAFE',
    4: 'PWD_SAFEST'
};

function getPasswordMessage(translates, msg)
{
    let result;
    
    switch (msg)
    {
        case 'Use a few words, avoid common phrases':
            result = translates.PWD_AVOID_COMMON_PHASE;
            break;
        case 'No need for symbols, digits, or uppercase letters':
            result = translates.PWD_NO_NEED;
            break;
        case 'Add another word or two. Uncommon words are better.':
            result = translates.PWD_MORE_WORDS;
            break;
        case 'Straight rows of keys are easy to guess':
            result = translates.PWD_STRAIGHT;
            break;
        case 'Short keyboard patterns are easy to guess':
            result = translates.PWD_SHORT_PATTERN;
            break;
        case 'Use a longer keyboard pattern with more turns':
            result = translates.PWD_LONG_PATTERN;
            break;
        case 'Repeats like "aaa" are easy to guess':
            result = translates.PWD_REPEATS_WARN;
            break;
        case 'Repeats like "abcabcabc" are only slightly harder to guess than "abc"':
            result = translates.PWD_REPEATS_PROMPT;
            break;
        case 'Avoid repeated words and characters':
            result = translates.PWD_AVOID_REPEAT;
            break;
        case 'Sequences like abc or 6543 are easy to guess':
            result = translates.PWD_SEQUENCES_WARN;
            break;
        case 'Avoid sequences':
            result = translates.PWD_AVOID_SEQUENCES;
            break;
        case 'Recent years are easy to guess':
            result = translates.PWD_RECENT_YEAR;
            break;
        case 'Avoid recent years':
            result = translates.PWD_AVOID_RECENT_YEAR;
            break;
        case 'Avoid years that are associated with you':
            result = translates.PWD_AVOID_YEAR;
            break;
        case 'Dates are often easy to guess':
            result = translates.PWD_DATES;
            break;
        case 'Avoid dates and years that are associated with you':
            result = translates.PWD_AVOID_DATES;
            break;
        case 'This is a top-10 common password':
            result = translates.PWD_TOP_10;
            break;
        case 'This is a top-100 common password':
            result = translates.PWD_TOP_100;
            break;
        case 'This is a very common password':
            result = translates.PWD_COMMON;
            break;
        case 'This is similar to a commonly used password':
            result = translates.PWD_SIMILAR;
            break;
        case 'A word by itself is easy to guess':
            result = translates.PWD_WORD;
            break;
        case 'Names and surnames by themselves are easy to guess':
            result = translates.PWD_NAMES;
            break;
        case 'Common names and surnames are easy to guess':
            result = translates.PWD_COMMON_NAME;
            break;
        case 'Capitalization doesn\'t help very much':
            result = translates.PWD_CAPITALIZATION;
            break;
        case 'All-uppercase is almost as easy to guess as all-lowercase':
            result = translates.PWD_UPPERCASE;
            break;
        case 'Reversed words aren\'t much harder to guess':
            result = translates.PWD_REVERSE;
            break;
        case 'Predictable substitutions like \'@\' instead of \'a\' don\'t help very much':
            result = translates.PWD_SUBSTITUTION;
            break;
        
        default:
            result = msg;
    }
    
    return result;
}

function getPasswordStrengthColor(score)
{
    const colors = {
        1: RED_A700,
        2: RED_A200,
        3: RED_A100,
        4: GREEN_A400,
        5: GREEN_A700
    };
    
    return colors[score];
}

export default class PasswordInput extends PureComponent {
    static contextTypes = {
        muiTheme: PropTypes.object.isRequired
    };
    
    static propTypes = {
        className      : PropTypes.string,
        strengthCheck  : PropTypes.bool,
        password       : PropTypes.string,
        name           : PropTypes.string,
        disabled       : PropTypes.bool,
        hintText       : PropTypes.string,
        style          : PropTypes.object,
        inputStyle     : PropTypes.object,
        hintStyle      : PropTypes.object,
        value          : PropTypes.any,
        getErrorMessage: PropTypes.func,
        setValue       : PropTypes.string,
        getValue       : PropTypes.string
    };
    
    state = {suggestions: [], password: null, focus: false};
    
    onPWDChange = (event) =>
    {
        const translates = getTranslateRecords(),
            value = event.target.value;
        
        if (zxcvbn && value)
        {
            const result = zxcvbn(value),
                suggestions = result.feedback.suggestions.map(suggestion => getPasswordMessage(translates, suggestion));
            
            if (result.feedback.warning)
                suggestions.unshift(getPasswordMessage(translates, result.feedback.warning));
            
            this.setState({
                              strength: result.score + 1,
                              password: value,
                              suggestions
                          });
        }
        else
        {
            this.setState({
                              strength   : 0,
                              password   : value,
                              suggestions: []
                          });
        }
        
        //this.props.setValue(event.currentTarget.value);
    };
    
    onFocus = (event) =>
    {
        
        const {password} = this.props;
        
        if (event.target.value === password)
        {
            this.setState({typing: true});
        }
        
        this.setState({focus: true});
    };
    
    debounceOnBlur = debounce(() =>
                              {
        
                                  if (!this.state.password)
                                  {
                                      this.setState({typing: false})
                                  }
        
                                  this.setState({focus: false});
        
                              }, 300);
    
    isSafePassword = () =>
    {
        return this.state.strength >= 4;
    };
    
    reset()
    {
        this.setState({
                          strength   : 0,
                          password   : null,
                          suggestions: []
                      })
    }
    
    onKeyDown = (keyEvent) =>
    {
        const {keyCode} = keyEvent;
        
        if (keyCode === 13)
        {
            if (keyEvent.target.value !== '')
                this.setState({focus: false});
        }
    };
    
    render()
    {
        
        const {
                strengthCheck, name, disabled, hintText, style,
                className, value,
                
                inputStyle = {fontSize: 14, color: WHITE},
                
                hintStyle = {fontSize: 14, color: GREY_189, fontWeight: FONT_NORMAL},
            
                validations,
                validationError
                
            } = this.props,
            
            color = this.context.muiTheme.textField.hintColor,
            translates = getTranslateRecords(),
            
            pwdVal = this.state.password !== null ? this.state.password : value,
            
            suggestionStyle = strengthCheck && (this.state.typing || (pwdVal && !this.isSafePassword())) ? {} :
                              {display: 'none'},
            strengthColor = getPasswordStrengthColor(this.state.strength),
            
            //errorText = this.props.getErrorMessage()
            errorText = this.pwdInput ? this.pwdInput.getErrorMessage() : ""
            
        ;
        
        return <div className={className} style={{position: 'relative'}}>
            <FormsyText fullWidth={true}
                       name={name}
                       ref={ref => this.pwdInput = ref}
                       type="password"
                       required
                       value={pwdVal}
                       hintText={hintText}
                       hintStyle={hintStyle}
                       disabled={disabled}
                       errorText={errorText}
                       inputStyle={inputStyle}
                       style={style}
                       onChange={this.onPWDChange}
                       onKeyDown={this.onKeyDown}
                       validations={validations}
                       //validationError={validationError}
            />
            
            <div style={{color, ...suggestionStyle}}>
                <p><span>{translates.PWD_STRENGTH}</span>:<span
                    style={{color: strengthColor}}>{translates[strengthLevels[this.state.strength - 1]]}</span>
                </p>
                
                <LinearProgress mode="determinate"
                                max={5}
                                color={strengthColor}
                                value={this.state.strength}/>
                
                {this.state.suggestions.map((suggestion, index) =>
                                            {
                                                return <div key={index}>{suggestion}</div>;
                                            })}
            
            </div>
        </div>
    }
}

//export default withFormsy(PasswordInput);
