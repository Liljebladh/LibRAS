within LibRAS.Sources;
  model MassFlowSource_T "Ideal flow source that produces a prescribed mass flow with prescribed temperature, mass fraction and trace substances"
    import Modelica.Media.Interfaces.Choices.IndependentVariables;
    extends LibRAS.Sources.PartialFlowSource;
    parameter Boolean use_m_flow_in = false "Get the mass flow rate from the input connector" annotation(Evaluate = true, HideResult = true, choices(checkBox = true));
    parameter Boolean use_T_in = false "Get the temperature from the input connector" annotation(Evaluate = true, HideResult = true, choices(checkBox = true));
    parameter Boolean use_X_in = false "Get the composition from the input connector" annotation(Evaluate = true, HideResult = true, choices(checkBox = true));
    parameter Boolean use_C_in = false "Get the trace substances from the input connector" annotation(Evaluate = true, HideResult = true, choices(checkBox = true));
    parameter Boolean use_C_S_in = false "Get the trace substances from the input connector" annotation(Evaluate = true, HideResult = true, choices(checkBox = true));
    parameter Boolean use_C_X_in = false "Get the trace substances from the input connector" annotation(Evaluate = true, HideResult = true, choices(checkBox = true));
    parameter Medium.MassFlowRate m_flow (displayUnit="kg/s") = 0 "Fixed mass flow rate going out of the fluid port" annotation(Evaluate = true, Dialog(enable = not use_m_flow_in));
    parameter Medium.Temperature T = Medium.T_default "Fixed value of temperature" annotation(Evaluate = true, Dialog(enable = not use_T_in));
    parameter Medium.MassFraction X[Medium.nX] = Medium.X_default "Fixed value of composition" annotation(Evaluate = true, Dialog(enable = not use_X_in and Medium.nXi > 0));
    parameter Medium.ExtraProperty C[Medium.nC](quantity = Medium.extraPropertiesNames) = fill(0, Medium.nC) "Fixed values of trace substances" annotation(Evaluate = true, Dialog(enable = not use_C_in and Medium.nC > 0));
    parameter Medium.ExtraProperty C_S[Medium.nC_S](quantity = Medium.solublesNames, each unit="kg/m3", each displayUnit="g/m3") = fill(Modelica.Constants.eps, Medium.nC_S) "Fixed values of dissolved substances" annotation(Evaluate = true, Dialog(enable = not use_C_S_in and Medium.nC_S > 0));
    parameter Medium.ExtraProperty C_X[Medium.nC_X](quantity = Medium.particulatesNames, each unit="kg/m3", each displayUnit="g/m3") = fill(Modelica.Constants.eps, Medium.nC_X) "Fixed values of particulate substances" annotation(Evaluate = true, Dialog(enable = not use_C_X_in and Medium.nC_X > 0));
    Modelica.Blocks.Interfaces.RealInput m_flow_in if use_m_flow_in "Prescribed mass flow rate" annotation(Placement(transformation(extent = {{-120, 60}, {-80, 100}}), iconTransformation(extent = {{-120, 60}, {-80, 100}})));
    Modelica.Blocks.Interfaces.RealInput T_in if use_T_in "Prescribed fluid temperature" annotation(Placement(transformation(extent = {{-140, 20}, {-100, 60}}), iconTransformation(extent = {{-140, 20}, {-100, 60}})));
    Modelica.Blocks.Interfaces.RealInput X_in[Medium.nX] if use_X_in "Prescribed fluid composition" annotation(Placement(transformation(extent = {{-140, -60}, {-100, -20}})));
    Modelica.Blocks.Interfaces.RealInput C_in[Medium.nC] if use_C_in "Prescribed boundary trace substances" annotation(Placement(transformation(extent = {{-120, -100}, {-80, -60}})));
    Modelica.Blocks.Interfaces.RealInput C_S_in[Medium.nC_S] if use_C_S_in "Prescribed boundary trace substances" annotation(Placement(transformation(origin = {-60, 100}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(extent = {{-20, -20}, {20, 20}}, rotation = -90)));
    Modelica.Blocks.Interfaces.RealInput C_X_in[Medium.nC_X] if use_C_X_in "Prescribed boundary trace substances" annotation(Placement(transformation(origin = {60, 100}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  protected
    Modelica.Blocks.Interfaces.RealInput m_flow_in_internal "Needed to connect to conditional connector";
    Modelica.Blocks.Interfaces.RealInput T_in_internal "Needed to connect to conditional connector";
    Modelica.Blocks.Interfaces.RealInput X_in_internal[Medium.nX] "Needed to connect to conditional connector";
    Modelica.Blocks.Interfaces.RealInput C_in_internal[Medium.nC] "Needed to connect to conditional connector";
    Modelica.Blocks.Interfaces.RealInput C_S_in_internal[Medium.nC_S] "Needed to connect to conditional connector";
    Modelica.Blocks.Interfaces.RealInput C_X_in_internal[Medium.nC_X] "Needed to connect to conditional connector";
  equation
    Modelica.Fluid.Utilities.checkBoundary(Medium.mediumName, Medium.substanceNames, Medium.singleState, true, X_in_internal, "MassFlowSource_T");
    connect(m_flow_in, m_flow_in_internal);
    connect(T_in, T_in_internal);
    connect(X_in, X_in_internal);
    connect(C_in, C_in_internal);
    connect(C_S_in, C_S_in_internal);
    connect(C_X_in, C_X_in_internal);
    if not use_m_flow_in then
      m_flow_in_internal = m_flow;
    end if;
    if not use_T_in then
      T_in_internal = T;
    end if;
    if not use_X_in then
      X_in_internal = X;
    end if;
    if not use_C_in then
      C_in_internal = C;
    end if;
    if not use_C_S_in then
      C_S_in_internal = C_S;
    end if;
    if not use_C_X_in then
      C_X_in_internal = C_X;
    end if;
    if Medium.ThermoStates == IndependentVariables.ph or Medium.ThermoStates == IndependentVariables.phX then
      medium.h = Medium.specificEnthalpy(Medium.setState_pTX(medium.p, T_in_internal, X_in_internal));
    else
      medium.T = T_in_internal;
    end if;
    sum(ports.m_flow) = -m_flow_in_internal;
    medium.Xi = X_in_internal[1:Medium.nXi];
    ports.C_outflow = fill(C_in_internal, nPorts);
    ports.C_S_outflow = fill(C_S_in_internal, nPorts);
    ports.C_X_outflow = fill(C_X_in_internal, nPorts);
    annotation(defaultComponentName = "boundary", Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(extent = {{35, 45}, {100, -45}}, lineColor = {0, 0, 0}, fillPattern = FillPattern.HorizontalCylinder, fillColor = {0, 127, 255}), Ellipse(extent = {{-100, 80}, {60, -80}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Polygon(points = {{-60, 70}, {60, 0}, {-60, -68}, {-60, 70}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid), Text(extent = {{-54, 32}, {16, -30}}, lineColor = {255, 0, 0}, textString = "m"), Text(extent = {{-150, 130}, {150, 170}}, textString = "%name", lineColor = {0, 0, 255}), Ellipse(extent = {{-26, 30}, {-18, 22}}, lineColor = {255, 0, 0}, fillColor = {255, 0, 0}, fillPattern = FillPattern.Solid), Text(visible = use_m_flow_in, extent = {{-185, 132}, {-45, 100}}, lineColor = {0, 0, 0}, textString = "m_flow"), Text(visible = use_T_in, extent = {{-111, 71}, {-71, 37}}, lineColor = {0, 0, 0}, textString = "T"), Text(visible = use_X_in, extent = {{-153, -44}, {-33, -72}}, lineColor = {0, 0, 0}, textString = "X"), Text(visible = use_C_in, extent = {{-155, -98}, {-35, -126}}, lineColor = {0, 0, 0}, textString = "C")}), Documentation(info = "<html>
<p>
Models an ideal flow source, with prescribed values of flow rate, temperature, composition and trace substances:
</p>
<ul>
<li> Prescribed mass flow rate.</li>
<li> Prescribed temperature.</li>
<li> Boundary composition (only for multi-substance or trace-substance flow).</li>
</ul>
<p>If <code>use_m_flow_in</code> is false (default option), the <code>m_flow</code> parameter
is used as boundary pressure, and the <code>m_flow_in</code> input connector is disabled; if <code>use_m_flow_in</code> is true, then the <code>m_flow</code> parameter is ignored, and the value provided by the input connector is used instead.</p>
<p>The same thing goes for the temperature and composition</p>
<p>
Note, that boundary temperature,
mass fractions and trace substances have only an effect if the mass flow
is from the boundary into the port. If mass is flowing from
the port into the boundary, the boundary definitions,
with exception of boundary flow rate, do not have an effect.
</p>
</html>"));
  end MassFlowSource_T;
