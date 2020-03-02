import React from "react"
import { BrowserRouter, Switch, Route } from "react-router-dom";
import PropTypes from "prop-types"
import Home from "./Home";
class App extends React.Component {
  render () {
    return (
      <BrowserRouter>
        <Switch>
          <Route exact path={"/"} render={() => <Home/>}/>
          <Route path={"/widgets"} render={() => ("Home!")}/>
        </Switch>
      </BrowserRouter>
    );
  }
}

export default App
