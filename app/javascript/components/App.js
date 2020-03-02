import React from "react"
import { BrowserRouter, Switch, Route } from "react-router-dom";
import PropTypes from "prop-types"
import Widgets from "./Widgets";
class App extends React.Component {
  render () {
    return (
      <BrowserRouter>
        <Switch>
          <Route exact path={"/"} render={() => <Widgets />}/>
          <Route path={"/widgets"} render={() => <Widgets personal />}/>
        </Switch>
      </BrowserRouter>
    );
  }
}

export default App
