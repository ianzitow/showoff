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
  Image,
  Input,
  List,
  Menu,
  Modal,
  Search,
  Segment
} from 'semantic-ui-react'
import axios from 'axios';
import _ from 'lodash';

class HelloWorld extends React.Component {

  state = {
    username: '',
    password: '',
    access_token: '9964172e175ccfda776994114e3ffc043ca2309b4f58f53db2ccccb2c008c256',
    refresh_token: '9e3ef84df34e77a122c1871adf506a1cb4a048566734c623d15b456b3a5d09d3',
    isLoggedIn: true,
    widgets: [],
    isLoading: false,
    searchValue: ''
  }

  handleChange = (e, { name, value }) => this.setState({ [name]: value })

  handleSubmit = () => {
    const { username, password } = this.state

    axios.post('api/v1/authentication/create', { authentication: { username: username, password: password }})
        .then(response => {
          this.setState({ access_token: response.data.data.token.access_token,
                                refresh_token: response.data.data.token.refresh_token,
                                isLoggedIn: true })
        })
        .catch(error => {
          console.log(error)
        })
  }

  handleSearchChange = (e, data) => {
    const { value } = data
    const { access_token } = this.state
    this.setState({ isLoading: (value.length >= 1), searchValue: value })
    console.log('called', value)
    axios.get('api/v1/widgets/visible', { params: { term: value } , headers: { 'Authorization': 'Bearer ' + access_token }})
        .then(response => {
          this.setState({ widgets: response.data.data.widgets, isLoading: false })
        })
        .catch(error => {
          this.setState({ isLoading: false })
          console.log(error)
        })
  }

  fetchVisibleWidgets = () => {
    const { access_token } = this.state
    axios.get('api/v1/widgets/visible', { headers: { 'Authorization': 'Bearer ' + access_token }})
        .then(response => {
          this.setState({ widgets: response.data.data.widgets })
        })
        .catch(error => {
          console.log(error)
        })
  }

  componentDidMount() {
    this.fetchVisibleWidgets()
  }

  render () {
    const { username, password, isLoading, searchValue } = this.state

    return (
        <div>
          <Menu fixed='top' inverted>
            <Container>
              <Menu.Item as='a' header>
                Showff Test
              </Menu.Item>
              <Menu.Item as='a'>Home</Menu.Item>
              {!this.state.isLoggedIn &&
              <Modal trigger={<Menu.Item position='right'>Login</Menu.Item>}>
                <Modal.Header>Login</Modal.Header>
                <Modal.Content>
                  <Form onSubmit={this.handleSubmit}>
                    <Form.Input label='Enter Username'
                                name='username'
                                value={username}
                                onChange={this.handleChange} />
                    <Form.Input label='Enter Password'
                                type='password'
                                name='password'
                                value={password}
                                onChange={this.handleChange} />
                    <Form.Field>
                      <Checkbox label='I agree to the Terms and Conditions' />
                    </Form.Field>
                    <Button type='submit'>Submit</Button>
                  </Form>
                </Modal.Content>
              </Modal>}
            </Container>
          </Menu>

          <Container text style={{ marginTop: '7em' }}>
            <Header as='h1'>Widgets</Header>
            <p>This is a basic fixed menu template using fixed size containers.</p>
            <p>
              A text container is used for the main container, which is useful for single column layouts.
            </p>

            <Input fluid placeholder='Search...' loading={isLoading} icon='search' onChange={_.debounce(this.handleSearchChange, 500, {leading: true})} />

              <Card.Group itemsPerRow={2} style={{ marginTop: '1em' }}>
                  {this.state.widgets.map(widget => {
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

HelloWorld.propTypes = {
  greeting: PropTypes.string
};
export default HelloWorld
