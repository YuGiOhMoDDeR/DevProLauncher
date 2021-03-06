--ストイック・チャレンジ
function c37364101.initial_effect(c)
  c:SetUniqueOnField(1,0,37364101)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c37364101.target)
	e1:SetOperation(c37364101.operation)
	c:RegisterEffect(e1)
	--Atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c37364101.atkval)
	c:RegisterEffect(e2)
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c37364101.eqlimit)
	c:RegisterEffect(e3)
	--cannot activate
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_CANNOT_TRIGGER)
	c:RegisterEffect(e4)
	--double damage
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e5:SetCondition(c37364101.dcon)
	e5:SetOperation(c37364101.dop)
	c:RegisterEffect(e5)
	--Sent To Grave
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TOGRAVE)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetRange(LOCATION_SZONE)
	e6:SetProperty(EFFECT_FLAG_REPEAT)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetCondition(c37364101.retcon)
	e6:SetOperation(c37364101.retop)
	c:RegisterEffect(e6)
	--Destroy
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_LEAVE_FIELD)
	e7:SetCondition(c37364101.descon)
	e7:SetOperation(c37364101.desop)
	c:RegisterEffect(e7)
end
function c37364101.eqlimit(e,c)
	return c:IsType(TYPE_XYZ) and c:GetOverlayCount() > 0
end
function c37364101.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetOverlayCount() > 0
end
function c37364101.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c37364101.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c37364101.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c37364101.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end

function c37364101.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
		c:SetCardTarget(tc)
	end
end

function c37364101.atkfilter(c)
	return c:GetOverlayCount()>0
end

function c37364101.atkval(e)
	local g=Duel.GetMatchingGroup(c37364101.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)
	local val = 0
	local gc=g:GetFirst()
	
	while gc do
		val = val + gc:GetOverlayCount()
		gc=g:GetNext()
	end
	
	return val*600
end
function c37364101.dcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler():GetEquipTarget()
	local at = Duel.GetAttackTarget()
	local a = Duel.GetAttacker()
	return at and a and c:IsControler(tp) and (at==c or a==c)
end
function c37364101.dop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(1-tp,ev*2)
end
function c37364101.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c37364101.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SendtoGrave(c,nil,REASON_EFFECT)
end
function c37364101.descon(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=c:GetFirstCardTarget()
	if tc and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() and c:IsLocation(LOCATION_GRAVE) then
		e:SetLabelObject(tc)
		tc:CreateEffectRelation(e)
		return true
		else return false 
	end
end
function c37364101.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if tc and tc:IsLocation(LOCATION_MZONE) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
