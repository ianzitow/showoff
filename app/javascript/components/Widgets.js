import React from "react"
import PropTypes from "prop-types"
import 'semantic-ui-css/semantic.min.css'
import {
  Button,
  Card,
  Checkbox,
  Container,
  Divider,
  Dropdown,
  Form,
  Grid,
  Header,
  Icon,
  Image,
  Input,
  List,
  Menu,
  Message,
    Modal,
  Search,
  Segment
} from 'semantic-ui-react'
import axios from 'axios';
import _ from 'lodash';
import Navbar from "./Navbar";
import WidgetForm from "./WidgetForm";
import { withRouter } from "react-router-dom";

class Widgets extends React.Component {

  state = {
    username: '',
    password: '',
    access_token: '',
    refresh_token: '',
    isLoggedIn: false,
    widgets: [],
    isLoading: false,
    searchValue: '',
    email: '',
    first_name: '',
    last_name: '',
    image_url: '',
    message: '',
    name: '',
    description: '',
    visible: true,
    isWidgetModalOpen: false
  }

    componentDidMount() {
      this.setState({
          access_token: localStorage.getItem("access_token"),
          refresh_token: localStorage.getItem("refresh_token")
      }, () => {
          if (this.state.access_token && this.state.refresh_token) {
              this.setState({isLoggedIn: true})
              this.fetchWidgets()
          }
      })
    }
    componentDidUpdate(prevProps) {
        if (this.props.personal !== prevProps.personal) {
            this.fetchWidgets()
        }
    }

  handleChange = (e, { name, value }) => {
      this.setState({ [name]: value })
  }

  handleSubmit = (method) => {
    if (method === 'login') {
      const {username, password} = this.state

      axios.post('api/v1/authentication/create', {authentication: {username: username, password: password}})
          .then(response => {
            this.setState({
              access_token: response.data.data.token.access_token,
              refresh_token: response.data.data.token.refresh_token,
              isLoggedIn: true
            }, () => {
                localStorage.setItem("access_token", this.state.access_token)
                localStorage.setItem("refresh_token", this.state.refresh_token)
                this.fetchWidgets()
            })
          })
          .catch(error => {
            console.log(error)
          })
    } else if (method === 'register') {
      const { email, password, first_name, last_name, image_url } = this.state

      axios.post('api/v1/users/create', {user: {email, password, first_name, last_name, image_url}})
          .then(response => {
            this.setState({
              access_token: response.data.data.token.access_token,
              refresh_token: response.data.data.token.refresh_token,
                isLoggedIn: true
            }, () => {
                localStorage.setItem("access_token", this.state.access_token)
                localStorage.setItem("refresh_token", this.state.refresh_token)
            })
          })
          .catch(error => {
            console.log(error)
          })
    } else if (method === 'reset') {
      const {username} = this.state

      axios.post('api/v1/users/reset_password', {user: {email: username}})
          .then(response => {
            this.setState({
              message: response.data.message
            })
          })
          .catch(error => {
            console.log(error)
          })
    } else if (method === 'create-widget') {
        const {name, description, visible, access_token} = this.state

        axios.post('api/v1/widgets', {widget: {name, description, kind: visible ? 'visible' : 'hidden' }}, { headers: { 'Authorization': 'Bearer ' + access_token } })
            .then(response => {
                this.setState({
                    message: response.data.message
                })
            })
            .catch(error => {
                console.log(error)
            })
    }
  }

  handleSearchChange = (e, data) => {
    const { value } = data
    const { access_token } = this.state
    this.setState({ isLoading: (value.length >= 1), searchValue: value })
    console.log('called', value)
    axios.get(this.props.personal ? 'api/v1/users/me/widgets' : 'api/v1/widgets/visible', { params: { term: value } , headers: { 'Authorization': 'Bearer ' + access_token }})
        .then(response => {
          this.setState({ widgets: response.data.data.widgets, isLoading: false })
        })
        .catch(error => {
          this.setState({ isLoading: false })
          console.log(error)
        })
  }

    handleModalClose = () => this.setState({isWidgetModalOpen: false})
    handleModalOpen = () => this.setState({isWidgetModalOpen: true})

    handleLogout = () => {
      this.setState({isLoggedIn: false, access_token: '', refresh_token: '', widgets: []}, () => {
          localStorage.removeItem("access_token")
          localStorage.removeItem("refresh_token")
          this.props.history.push('/')
      })
    }

  fetchWidgets = () => {
    const { access_token } = this.state
    axios.get(this.props.personal ? 'api/v1/users/me/widgets' : 'api/v1/widgets/visible', { headers: { 'Authorization': 'Bearer ' + access_token }})
        .then(response => {
          this.setState({ widgets: response.data.data.widgets })
        })
        .catch(error => {
          console.log(error)
        })
  }

  render () {
    const { username,
        password,
        isLoading,
        widgets,
        email,
        first_name,
        last_name,
        image_url,
        name,
        description,
        visible,
        isLoggedIn,
        isWidgetModalOpen,
        message } = this.state

    return (
        <div>
          <Navbar loggedIn={isLoggedIn} onLogout={this.handleLogout}
                  onSubmit={this.handleSubmit} username={username}
                  onChange={this.handleChange} password={password}
          email={email} first_name={first_name} last_name={last_name} image_url={image_url}/>

          <Container text style={{marginTop: '7em'}}>
              {message !== '' && <Message info>
                  <Message.Header>Info</Message.Header>
                  <p>{message}</p>
              </Message>}
            <Header as='h1'>{this.props.personal ? "My Widgets" : "Widgets"}</Header>

              <Button onClick={this.handleModalOpen} primary><Icon name='add' />Create Widget</Button>
              <Modal open={isWidgetModalOpen}>
                  <Modal.Header>Create Widget</Modal.Header>
                  <Modal.Content>
                      <WidgetForm
                          name={name}
                          description={description}
                          visible={visible}
                          onChange={this.handleChange}
                          onSubmit={this.handleSubmit}
                          onCloseModal={this.handleModalClose}/>
                  </Modal.Content>
              </Modal>

            <Input style={{marginTop: '1em'}} fluid placeholder='Search...' loading={isLoading} icon='search'
                   onChange={_.debounce(this.handleSearchChange, 500, {leading: true})}/>

            <Card.Group itemsPerRow={2} style={{marginTop: '1em'}}>
              {widgets.map(widget => {
                return (<Card key={widget.id} fluid>
                  <Card.Content>
                    <Image
                        floated='right'
                        size='mini'
                        src={widget.user.images.small_url}
                    />
                    <Card.Header>{widget.name}</Card.Header>
                    <Card.Meta>{widget.user.name}</Card.Meta>
                    <Card.Description>
                      {widget.description}
                    </Card.Description>
                  </Card.Content>
                </Card>)
              })}

            </Card.Group>
          </Container>


        </div>
    );
  }
}

Widgets.propTypes = {
  personal: PropTypes.bool
};

export default withRouter(Widgets)
